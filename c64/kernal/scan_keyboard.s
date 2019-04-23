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

	lda #$00
	sta BufferQuantity
	
	;; Decrement key repeat timeout if non-zero
	ldx key_repeat_counter
	stx $0427
	beq sk_start
	dec key_repeat_counter
	
sk_start:	
	;; Call main keyboard scanning routine
	jsr Main

	lda BufferQuantity
	sta $0420
	beq no_keys_waiting
	
	;; Stuff each key pressed into the keyboard buffer

	ldy #$00
*
	lda Buffer,y
	sta $0424,y
	jsr accept_key
	iny
	cpy BufferQuantity
	bne -
no_keys_waiting:
	
	rts

accept_key:	
	;; Work out what is new and needs to be added
	;; to the input buffer.
	;; Also update the bucky key status flags etc
	cmp #$ff
	beq sk_nokey
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
	beq sk_nokey

	sta $044c,y
	
	;; Stash key into keyboard buffer
	ldx keys_in_key_buffer
	cpx key_buffer_size
	beq sk_nokey
	sta keyboard_buffer,x
	inc keys_in_key_buffer
	
sk_nokey:	

	rts
	

	;; //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	;; // Routine for Scanning a Matrix Row

KeyInRow:
	ldy #7
NextKeyInRow:	
	ror
	bcs nokey
	jsr KeyFound
nokey:
	inx
	dey
	bpl NextKeyInRow

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

TooManyNewKeys:
ReturnNoKeys:	
	sec
	lda #$00
	sta BufferQuantity
	lda #$FF
	sta Buffer+0
	sta Buffer+1
	sta Buffer+2
	rts


	;; //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	;; // Exit Routine for: No Activity

NoActivityDetected:
	;; So cancel all bucky keys
	lda key_bucky_state
	sta key_last_bucky_state
	lda #$00
	sta key_bucky_state

	jmp ReturnNoKeys

	;; //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	;; // Configure Data Direction Registers
Main:
	;; Begin with no key events
	lda #$ff
	sta BufferNew+0
	sta BufferNew+1
	sta BufferNew+2
	
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
	bne ReturnNoKeys

	;; //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	;; // Scan Keyboard Matrix

	ldx #7
	lda #%11111110
next_row:	
	sta $dc00
	pha
	lda $dc01
	sta ScanResult,x
	pla
	sec
        rol
	dex
	bpl next_row

	;; X gets back to $FF here, which is assumed below

	;; //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	;; // Check for Control Port #1 Activity (again)

	stx $dc00       ;// Disconnect all Keyboard Rows
	cpx $dc01       ;// Only Control Port activity will be detected
	bne ReturnNoKeys

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
	and #%10000000     ;// Left shift
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

	;; Vendor key
	lda ScanResult+0
	eor #$ff
	lsr
	lsr
	lsr
	lsr
	and #$02
	ora key_bucky_state
	sta key_bucky_state

	;; Chick for shift + Vendor
	cmp #$03
	bne no_case_toggle
	lda key_last_bucky_state
	cmp #$03
	beq no_case_toggle

	lda enable_case_switch
	beq no_case_toggle
	
	lda $D018
	eor #$02
	sta $d018

no_case_toggle:	
	
	;; //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	;; // Check for pressed key(s)

	lda ScanResult+7
	cmp #$ff
	beq sk6
        jsr KeyInRow
sk6:	
        ldx #8
        lda ScanResult+6
        beq sk5
        jsr KeyInRow
sk5:	
        ldx #16
        lda ScanResult+5
        beq sk4
        jsr KeyInRow
sk4:	
        ldx #24
        lda ScanResult+4
        beq sk3
        jsr KeyInRow
sk3:	
        ldx #32
        lda ScanResult+3
        beq sk2
        jsr KeyInRow
sk2:	
        ldx #40
        lda ScanResult+2
        beq sk1
        jsr KeyInRow
sk1:	
        ldx #48
        lda ScanResult+1
        beq sk0
        jsr KeyInRow
sk0:	
        ldx #56
        lda ScanResult+0
        beq skdone
        jsr KeyInRow
skdone:	



    ;; //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    ;; // Key Scan Completed

	;; // Put any new key (not in old scan) into buffer
        ldx #MaxKeyRollover-1

ProcessPressedKeys:	

	;; Check if the currently pressed key is continuing to be held down
	lda BufferNew,x
	sta $0400,x
        cmp #$ff
        beq ConsiderNextKey
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
	bcs TooManyNewKeys
AcceptKeyEvent:	
        sta Buffer,y
	sta $0428,y
	iny
	sty BufferQuantity
	
ConsiderNextKey:
        dex
        bpl ProcessPressedKeys

	;; Return success and set of pressed keys
	clc
	rts

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
	jmp ConsiderNextKey
	
SameKeyHeld:
	ldx key_repeat_counter
	beq KeyCanRepeat
	dec key_repeat_counter
	bne KeyRepeatWait
	;; Count down ended, so repeat key now
KeyCanRepeat:	

	;; (Compute's Mapping the 64 p58)
	pha
	lda #6-2  		; Fudge factor to match speed
	sta key_repeat_counter
	pla

	jmp RecordKeypress
KeyRepeatWait:	
	jmp ConsiderNextKey


