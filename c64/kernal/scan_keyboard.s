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


;;     Preparatory Settings
;;     ~~~~~~~~~~~~~~~~~~~~
;;         None


;;     Destroys
;;     ~~~~~~~~
;;         Accumulator
;;         X-Register
;;         Y-Register
;;         Carry / Zero / Negative
;;         $dc00
;;         $dc01
;;         $50-$5f


;;     Footprint
;;     ~~~~~~~~~
;;         #$206 Bytes


;;     Information
;;     ~~~~~~~~~~~
;;         The routine uses "2 Key rollower" or up to 3 if the key-combination doesen't induce shadowing.
;;         If 2 or 3 keys are pressed simultaneously (within 1 scan) a "No Activity" state has to occur before new valid keys are returned.
;;         RESTORE is not detectable and must be handled by NMI IRQ.
;;         SHIFT LOCK is not detected due to unreliability.


;;     Usage
;;     ~~~~~
;;       Example Code:

;;             jsr Keyboard
;;             bcs NoValidInput
;;                 stx TempX
;;                 sty TempY
;;                 cmp #$ff
;;                 beq NoNewAphanumericKey
;;                     // Check A for Alphanumeric keys
;;                     sta $0400
;;             NoNewAphanumericKey:
;;             // Check X & Y for Non-Alphanumeric Keys
;;             ldx TempX
;;             ldy TempY
;;             stx $0401
;;             sty $0402
;;        NoValidInput:  // This may be substituted for an errorhandler if needed.


;;     Returned
;;     ~~~~~~~~

;;         +=================================================+
;;         |             Returned in Accumulator             |
;;         +===========+===========+=============+===========+
;;         |  $00 - @  |  $10 - p  |  $20 - SPC  |  $30 - 0  |
;;         |  $01 - a  |  $11 - q  |  $21 -      |  $31 - 1  |
;;         |  $02 - b  |  $12 - r  |  $22 -      |  $32 - 2  |
;;         |  $03 - c  |  $13 - s  |  $23 -      |  $33 - 3  |
;;         |  $04 - d  |  $14 - t  |  $24 -      |  $34 - 4  |
;;         |  $05 - e  |  $15 - u  |  $25 -      |  $35 - 5  |
;;         |  $06 - f  |  $16 - v  |  $26 -      |  $36 - 6  |
;;         |  $07 - g  |  $17 - w  |  $27 -      |  $37 - 7  |
;;         |  $08 - h  |  $18 - x  |  $28 -      |  $38 - 8  |
;;         |  $09 - i  |  $19 - y  |  $29 -      |  $39 - 9  |
;;         |  $0a - j  |  $1a - z  |  $2a - *    |  $3a - :  |
;;         |  $0b - k  |  $1b -    |  $2b - +    |  $3b - ;  |
;;         |  $0c - l  |  $1c - £  |  $2c - ,    |  $3c -    |
;;         |  $0d - m  |  $1d -    |  $2d - -    |  $3d - =  |
;;         |  $0e - n  |  $1e - ^  |  $2e - .    |  $3e -    |
;;         |  $0f - o  |  $1f - <- |  $2f - /    |  $3f -    |
;;         +-----------+-----------+-------------+-----------+

;;         +================================================================================
;;         |                             Return in X-Register                              |
;;         +=========+=========+=========+=========+=========+=========+=========+=========+
;;         |  Bit 7  |  Bit 6  |  Bit 5  |  Bit 4  |  Bit 3  |  Bit 2  |  Bit 1  |  Bit 0  |
;;         +---------+---------+---------+---------+---------+---------+---------+---------+
;;         | CRSR UD |   F5    |   F3    |   F1    |   F7    | CRSR RL | RETURN  |INST/DEL |
;;         +---------+---------+---------+---------+---------+---------+---------+---------+

;;         +================================================================================
;;         |                             Return in Y-Register                              |
;;         +=========+=========+=========+=========+=========+=========+=========+=========+
;;         |  Bit 7  |  Bit 6  |  Bit 5  |  Bit 4  |  Bit 3  |  Bit 2  |  Bit 1  |  Bit 0  |
;;         +---------+---------+---------+---------+---------+---------+---------+---------+
;;         |RUN STOP | L-SHIFT |   C=    | R-SHIFT |CLR/HOME |  CTRL   |         |         |
;;         +---------+---------+---------+---------+---------+---------+---------+---------+

;;         CARRY:
;;           - Set = Error Condition (Check A for code):
;;               A = #$01 => No keyboard activity is detected.
;;               A = #$02 => Control Port #1 Activity is detected.
;;               A = #$03 => Key Shadowing / Ghosting is detected.
;;               A = #$04 => 2 or 3 new keys is detected within one scan
;;               A = #$05 => Awaiting "No Activity" state
;;           - Clear = Valid input
;;               A =  #$ff => No new Alphanumeric Keys detected (some key(s) being held down AND/OR some Non-Alphanumeric key is causing valid return).
;;               A <> #$ff => New Alphanumeric Key returned. Non-Alphanumeric keys may also be returned in X or Y Register

;;     Issues/ToDo:
;;     ~~~~~~~~~~~~
;;         - None


;;     Improvements:
;;     ~~~~~~~~~~~~~
;;         - Replace the subroutine with a pseudocommand and account for speedcode parameter (Memory vs. Cycles).
;;         - Shorten the routine / Optimize if possible.


;;     History:
;;     ~~~~~~~~
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

    ;; .pc = * "Keyboard Scan Routine"


	;; // ZERO PAGE Varibles
	;; $250-$258 is the 81st - 88th characters in BASIC input, a carry over from VIC-20
	;; and not used on C64, so safe for us to use, probably.
	;; (Compute's Mapping the 64 p51)
	.alias ScanResult        $250 ;// 8 bytes
	;; Other variables are in RS232 ZP locations for now
	;; (Carefully avoiding $A7 which is used by 64NET)
    .alias BufferNew         $A9  ;// 3 bytes
    .alias KeyQuantity       $A8  ;// 1 byte
    .alias NonAlphaFlagX     $B4  ;// 1 byte
    .alias NonAlphaFlagY     $B5  ;// 1 byte
    .alias TempZP            $B6  ;// 1 byte
    .alias SimultaneousKeys  $F7  ;// 1 byte

    ;// Operational Variables
    .alias MaxKeyRollover 3

Keyboard:
    jmp Main


    ;; //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    ;; // Routine for Scanning a Matrix Row

KeyInRow:
	asl
	bcs nokey0
	jsr KeyFound
nokey0:	
        inx
        asl
        bcs nokey1
        jsr KeyFound
nokey1:	
        inx
        asl
        bcs nokey2
        jsr KeyFound
nokey2:	
        inx
        asl
        bcs nokey3
        jsr KeyFound
nokey3:	
        inx
        asl
        bcs nokey4
        jsr KeyFound
nokey4:	
        inx
        asl
        bcs nokey5
        jsr KeyFound
nokey5:	
        inx
        asl
        bcs nokey6
        jsr KeyFound
nokey6:	
        inx
        asl
        bcs nokey7
        jsr KeyFound
nokey7:	

    rts


    ;; //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    ;; // Routine for handling: Key Found

KeyFound:
    stx TempZP
    dec KeyQuantity
    bmi OverFlow
    ldy KeyTable,x
    ldx KeyQuantity
    sty BufferNew,x
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
    lda #$03
    sec
    rts


    ;; //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    ;; // Exit Routine for: No Activity

NoActivityDetected:
    ;; // Exit With A = #$01, Carry Set & Reset BufferOld.
    lda #$00
    sta SimultaneousAlphanumericKeysFlag  ;// Clear the too many keys flag once a "no activity" state is detected.
    stx BufferOld
    stx BufferOld+1
    stx BufferOld+2
    sec
    lda #$01
    rts


    ;; //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    ;; // Exit Routine for Control Port Activity

ControlPort:
    ;; // Exit with A = #$02, Carry Set. Keep BufferOld to verify input after Control Port activity ceases
    sec
    lda #$02
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

    lda SimultaneousAlphanumericKeysFlag
    beq skip0
        ;; // Waiting for all keys to be released before accepting new input.
        lda #$05
        sec
        rts
skip0:

    ;; //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    ;; // Check for Control Port #1 Activity

    stx $dc00       ;// Disconnect all Keyboard Rows
    cpx $dc01       ;// Only Control Port activity will be detected
    bne ControlPort


    ;; //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    ;; // Scan Keyboard Matrix

    lda #%11111110
    sta $dc00
    ldy $dc01
    sty ScanResult+7
    sec

        rol
        sta $dc00
        ldy $dc01
        sty ScanResult+6

        rol
        sta $dc00
        ldy $dc01
        sty ScanResult+5

        rol
        sta $dc00
        ldy $dc01
        sty ScanResult+4

        rol
        sta $dc00
        ldy $dc01
        sty ScanResult+3

        rol
        sta $dc00
        ldy $dc01
        sty ScanResult+2

        rol
        sta $dc00
        ldy $dc01
        sty ScanResult+1

        rol
        sta $dc00
        ldy $dc01
        sty ScanResult+0



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

    ;; // Reset Non-AlphaNumeric Flag
    inx
    stx NonAlphaFlagY

    ;; // Set max keys allowed before ignoring result
    lda #MaxKeyRollover
    sta KeyQuantity

    ;; // Counter to check for simultaneous alphanumeric key-presses
    lda #$fe
    sta SimultaneousKeys


    ;; //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    ;; // Check and flag Non Alphanumeric Keys

    lda ScanResult+6
    eor #$ff
    and #%10000000     ;// Left Shift
    lsr
    sta NonAlphaFlagY
    lda ScanResult+0
    eor #$ff
    and #%10100100     ;// RUN STOP - C= - CTRL
    ora NonAlphaFlagY
    sta NonAlphaFlagY
    lda ScanResult+1
    eor #$ff
    and #%00011000     ;// Right SHIFT - CLR HOME
    ora NonAlphaFlagY
    sta NonAlphaFlagY

    lda ScanResult+7  ;// The rest
    eor #$ff
    sta NonAlphaFlagX


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
        beq Exist
        cmp BufferOld+1
        beq Exist
        cmp BufferOld+2
        beq Exist
            ;; // New Key Detected
            inc BufferQuantity
            ldy BufferQuantity
            sta Buffer,y
            ;; // Keep track of how many new Alphanumeric keys are detected
            inc SimultaneousKeys
            beq TooManyNewKeys
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
    ;; // Handle Non Alphanumeric Keys
    ldx NonAlphaFlagX
    ldy NonAlphaFlagY
    rts

TooManyNewKeys:
    sec
    lda #$ff
    sta BufferQuantity
    sta SimultaneousAlphanumericKeysFlag
    lda #$04
    rts

;; //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
KeyTable:
    .byte $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff  ;// CRSR DOWN, F5, F3, F1, F7, CRSR RIGHT, RETURN, INST DEL
    .byte $ff, $05, $13, $1a, $34, $01, $17, $33  ;// LEFT SHIFT, "E", "S", "Z", "4", "A", "W", "3"
    .byte $18, $14, $06, $03, $36, $04, $12, $35  ;// "X", "T", "F", "C", "6", "D", "R", "5"
    .byte $16, $15, $08, $02, $38, $07, $19, $37  ;// "V", "U", "H", "B", "8", "G", "Y", "7"
    .byte $0e, $0f, $0b, $0d, $30, $0a, $09, $39  ;// "N", "O" (Oscar), "K", "M", "0" (Zero), "J", "I", "9"
    .byte $2c, $00, $3a, $2e, $2d, $0c, $10, $2b  ;// ",", "@", ":", ".", "-", "L", "P", "+"
    .byte $2f, $1e, $3d, $ff, $ff, $3b, $2a, $1c  ;// "/", "^", "=", RIGHT SHIFT, HOME, ";", "*", "£"
    .byte $ff, $11, $ff, $20, $32, $ff, $1f, $31  ;// RUN STOP, "Q", "C=" (CMD), " " (SPC), "2", "CTRL", "<-", "1"

BufferOld:
    .byte $ff, $ff, $ff

Buffer:
    .byte $ff, $ff, $ff, $ff

BufferQuantity:
    .byte $ff

SimultaneousAlphanumericKeysFlag:
    .byte $00
