	;; Scan the keyboard..
	;; Here we don't use the horrible buggy original routine,
	;; not just because of copyright. Instead, we use the
	;; nice one with joystick interference removal and
	;; key roll-over support from
	;; http://codebase64.org/doku.php?id=base:scanning_the_keyboard_the_correct_and_non_kernal_way

;; /*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;;     Keyboard IO Routine
;;     ~~~~~~~~~~~~~~~~~~~
;;         By: TWW/CTR


;;     Information
;;     ~~~~~~~~~~~
;;         The routine uses "2 Key rollower" or up to 3 if the key-combination doesen't induce shadowing.
;;         If 2 or 3 keys are pressed simultaneously (within 1 scan) a "No Activity" state has to occur before new valid keys are returned.
;;         RESTORE is not detectable and must be handled by NMI IRQ.
;;         SHIFT LOCK is not detected due to unreliability.


;;     History:
;;     ~~~~~~~~
;;     V3.0 - Hacked to pieces by PGS to work as KERNAL keyboard scan routine
;;     V2.5 - New test tool.
;;            Added return of error codes.
;;            Fixed a bug causing Buffer Overflow.
;;            Fixed a bug in Non Alphanumerical Flags from 2.0.
;;     V2.1 - Shortened the source by adding .for loops & Updated the header and some comments.
;;            Added "simultaneous keypress" check.
;;     V2.0 - Added return of non-Alphanumeric keys into X & Y-Registers.
;;            Small optimizations here and there.
;;     V1.1 - Unrolled code to make it faster and optimized other parts of it.
;;            Removed SHIFT LOCK scanning.
;;     V1.0 - First Working Version along with test tool.

;; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

	;; // ZERO PAGE Varibles
	;; $250-$258 is the 81st - 88th characters in BASIC input, a carry over from VIC-20
	;; and not used on C64, so safe for us to use, probably.
	;; (Compute's Mapping the 64 p51)
	.alias ScanResult        $250 ;// 8 bytes
	;; Other variables are in RS232 ZP locations for now
	;; (Carefully avoiding $A7 which is used by 64NET)
    .alias BufferNew         $A9  ;// 3 bytes
    .alias KeyQuantity       $A8  ;// 1 byte
    .alias TempZP            $B6  ;// 1 byte

	;; Reuse RS232 variables, since they should not be used
	;; by other things
	;; These are initialised in cinit all to $FF
    .alias BufferOld         $293 ; 3 bytes
	.alias Buffer 	$297 	; 4 bytes
	.alias BufferQuantity $B4 ; 1 byte


	
    ;// Operational Variables
    .alias MaxKeyRollover 3

scan_keyboard:
	;; Call main keyboard scanning routine
	jsr Main
	bcc +
	rts
*
	;; Work out what is new and needs to be added
	;; to the input buffer.
	;; Also update the bucky key status flags etc
	cmp #$ff
	beq +
	;; Got a key, turn it from matrix position to key value,
	;; and stuff it in the keyboard buffer

	;; Convert matrix position to key code
	;; XXX - Add offset of $40, $80 or $C0 if shift, CONTROL or C= are held down
	pha
	lda key_bucky_state
	and #$7
	tax
	pla
	and #$3f
	ora keyboard_matrix_lookup,x
	tax
	lda keyboard_matrixes,x
	;; But don't insert $00 characters
	beq +

	;; Stash key into keyboard buffer
	ldx keys_in_key_buffer
	cpx key_buffer_size
	beq +
	sta keyboard_buffer,x
	inc keys_in_key_buffer
	
	*

	rts
	

    ;; //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    ;; // Routine for Scanning a Matrix Row

KeyInRow:
	ldy #7
*
	ror
	bcs nokey
	jsr KeyFound
nokey:
	inx
	dey
	bpl -

	rts


    ;; //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    ;; // Routine for handling: Key Found

KeyFound:
	stx TempZP
	dec KeyQuantity
	bmi OverFlow

	;; Originally, we resolved the keys.
	;; Now we just return the matrix position, so that
	;; we can do C64-style bucky modifications as normal
	;; was: ldy KeyTable,x
	pha
	txa
	
	ldx KeyQuantity
	sta BufferNew,x
	pla
	ldx TempZP
	rts

    ;; //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    ;; // Routine for handling: Overflow

OverFlow:
    pla  ;// Dirty hack to handle 2 layers of JSR
    pla
    pla
    pla
    ;// Don't manipulate last legal buffer as the routine will fix itself once it gets valid input again.
	sec
	lda #$ff
    rts


    ;; //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    ;; // Exit Routine for: No Activity

NoActivityDetected:
	;; So cancel all bucky keys
	lda key_bucky_state
	sta key_last_bucky_state
	lda #$00
	sta key_bucky_state
	
    stx BufferOld
    stx BufferOld+1
    stx BufferOld+2
	sec
	lda #$ff
    rts


    ;; //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    ;; // Exit Routine for Control Port Activity

ControlPort:
    ;; // Exit with A = #$02, Carry Set. Keep BufferOld to verify input after Control Port activity ceases
	sec
	lda #$ff
    rts


    ;; //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    ;; // Configure Data Direction Registers
Main:
    ldx #$ff
    stx $dc02       ;// Port A - Output
    ldy #$00
    sty $dc03       ;// Port B - Input


    ;; //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    ;; // Check for Port Activity

    sty $dc00       ;// Connect all Keyboard Rows
    cpx $dc01
    beq NoActivityDetected

skip0:

    ;; //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    ;; // Check for Control Port #1 Activity

    stx $dc00       ;// Disconnect all Keyboard Rows
    cpx $dc01       ;// Only Control Port activity will be detected
    bne ControlPort


    ;; //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    ;; // Scan Keyboard Matrix

	ldx #7
	lda #%11111110
*	sta $dc00
	pha
	lda $dc01
	sta ScanResult,x
	pla
	sec
        rol
	dex
	bpl -

	;; X gets back to $FF here, which is assumed below

    ;; //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    ;; // Check for Control Port #1 Activity (again)

    stx $dc00       ;// Disconnect all Keyboard Rows
    cpx $dc01       ;// Only Control Port activity will be detected
    bne ControlPort


    ;; //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    ;; // Initialize Buffer, Flags and Max Keys

    ;; // Reset current read buffer
    stx BufferNew
    stx BufferNew+1
    stx BufferNew+2

	;; Make X = $00, assumed below
    inx

    ;; // Set max keys allowed before ignoring result
    lda #MaxKeyRollover
    sta KeyQuantity

    ;; //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    ;; // Check and flag Non Alphanumeric Keys

	;; Store last row of keyboard scan result,
	;; so that RUN/STOP etc can be checked easily
	;; (Compute's Mapping the 64, p27)
	lda ScanResult+0
	sta BUCKYSTATUS

	;; Store de-bounce data for bucky keys
	;; (Compute's Mapping the 64, p58-59)
	lda key_bucky_state
	sta key_last_bucky_state

	;; Build bucky state
	lda #$00
	sta key_bucky_state
	lda ScanResult+6
	eor #$ff
	and #%10000000     ;// Left Shift
	rol
	rol
	and #$01
	ora key_bucky_state
	sta key_bucky_state

	;; Right shift
	lda ScanResult+1
	eor #$ff
	lsr
	lsr
	lsr
	lsr
	and #$01
	ora key_bucky_state
	sta key_bucky_state
	
	;; Control
	lda ScanResult+0
	eor #$ff
	and #$04
	ora key_bucky_state
	sta key_bucky_state

	;; C= key
	lda ScanResult+0
	eor #$ff
	lsr
	lsr
	lsr
	lsr
	and #$02
	ora key_bucky_state
	sta key_bucky_state

    ;; //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    ;; // Check for pressed key(s)

    lda ScanResult+7
    cmp #$ff
    beq +
        jsr KeyInRow
*
        ldx #8
        lda ScanResult+6
        beq +
        jsr KeyInRow
	*
        ldx #16
        lda ScanResult+5
        beq +
        jsr KeyInRow
	*
        ldx #24
        lda ScanResult+4
        beq +
        jsr KeyInRow
	*
        ldx #32
        lda ScanResult+3
        beq +
        jsr KeyInRow
	*
        ldx #40
        lda ScanResult+2
        beq +
        jsr KeyInRow
	*
        ldx #48
        lda ScanResult+1
        beq +
        jsr KeyInRow
	*
        ldx #56
        lda ScanResult+0
        beq +
        jsr KeyInRow
	*



    ;; //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    ;; // Key Scan Completed

	;; // Put any new key (not in old scan) into buffer
    ldx #MaxKeyRollover-1
*      lda BufferNew,x
        cmp #$ff
        beq Exist        ;; // Handle 'null' values
        cmp BufferOld
        beq KeyHeld
        cmp BufferOld+1
        beq KeyHeld
        cmp BufferOld+2
        beq KeyHeld
RecordKeypress:	
        ;; // New Key Detected
	ldy BufferQuantity
	cpy #MaxKeyRollover
	bcc TooManyNewKeys

	iny
	sty BufferQuantity
        sta Buffer,y
    Exist:
        dex
        bpl -

    ;; // Anything in Buffer?
    ldy BufferQuantity
    bmi BufferEmpty
        ;; // Yes: Then return it and tidy up the buffer
        dec BufferQuantity
        lda Buffer
        ldx Buffer+1
        stx Buffer
        ldx Buffer+2
        stx Buffer+1
        jmp Return

KeyHeld:
	;; The key in A is still held down.
	;; compare with key in last_key_matrix_position
	;; (Compute's Mapping the 64 p36-37)
	;; if different, reset repeat count down.

	;; Ignore bucky keys, so that repeat can work when a
	;; bucky is held down.
	cmp #15
	beq BuckyHeld
	cmp #52
	beq BuckyHeld
	cmp #58
	beq BuckyHeld
	cmp #61
	beq BuckyHeld
	
	cmp last_key_matrix_position
	beq SameKeyHeld
	;; Different key held
	sta last_key_matrix_position
	pha
	lda key_first_repeat_delay
	sta key_repeat_counter
	pla
BuckyHeld:
	jmp Exist
	
SameKeyHeld:
	dec key_repeat_counter
	bne +
	;; Count down ended, so repeat key now

	;; Reload key repeat counter
	;; (Compute's Mapping the 64 p58)
	pha
	lda #6-2  		; Fudge factor to match speed
	sta key_repeat_counter
	pla

	jmp RecordKeypress
	
*	jmp Exist

BufferEmpty:  ;; // No new Alphanumeric keys to handle.
    lda #$ff

Return:  ;; // A is preset
    clc
    ;; // Copy BufferNew to BufferOld
    ldx BufferNew
    stx BufferOld
    ldx BufferNew+1
    stx BufferOld+1
    ldx BufferNew+2
    stx BufferOld+2

    rts

TooManyNewKeys:
	sec
	lda #$ff
	sta BufferQuantity
    rts

