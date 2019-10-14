
//
// Official Kernal routine, described in:
//
// - [RG64] C64 Programmer's Reference Guide   - page 295
// - [CM64] Compute's Mapping the Commodore 64 - page 220
//
// CPU registers that has to be preserved (see [RG64]): none
//


#if CONFIG_LEGACY_SCNKEY


// Scan the keyboard..
// Here we don't use the horrible buggy original routine,
// not just because of copyright. Instead, we use the
// nice one with joystick interference removal and
// key roll-over support from
// http://codebase64.org/doku.php?id=base:scanning_the_keyboard_the_correct_and_non_kernal_way

// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//     Keyboard IO Routine
//     ~~~~~~~~~~~~~~~~~~~
//         By: TWW/CTR


//     Information
//     ~~~~~~~~~~~
//         The routine uses "2 Key rollower" or up to 3 if the key-combination doesen't induce shadowing.
//         If 2 or 3 keys are pressed simultaneously (within 1 scan) a "No Activity" state has to occur before new valid keys are returned.
//         RESTORE is not detectable and must be handled by NMI IRQ.
//         SHIFT LOCK is not detected due to unreliability.


//     History:
//     ~~~~~~~~
//     V3.0 - Hacked to pieces by PGS to work as KERNAL keyboard scan routine
//     V2.5 - New test tool.
//            Added return of error codes.
//            Fixed a bug causing Buffer Overflow.
//            Fixed a bug in Non Alphanumerical Flags from 2.0.
//     V2.1 - Shortened the source by adding .for loops & Updated the header and some comments.
//            Added "simultaneous keypress" check.
//     V2.0 - Added return of non-Alphanumeric keys into X & Y-Registers.
//            Small optimizations here and there.
//     V1.1 - Unrolled code to make it faster and optimized other parts of it.
//            Removed SHIFT LOCK scanning.
//     V1.0 - First Working Version along with test tool.

// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

	// Low memory variables

	// Reuse RS232 variables, since they should not be used by other things.
	// Carefully avoid $A7 which is used by 64NET
	.label KeyQuantity       = $A8  // 1 byte
	.label BufferNew         = $A9  // 3 bytes
	.label TempZP            = $B6  // 1 byte
	// These should be initialized in CINT to $FF
	.label BufferQuantity    = $B4  // 1 byte
	.label BufferOld         = $293 // 3 bytes
	.label Buffer 	         = $297 // 4 bytes

	// $250-$258 is the 81st - 88th characters in BASIC input, a carry over from VIC-20
	// and not used on C64, so safe for us to use, probably.
	.label ScanResult = $250 // 8 bytes

	// Operational Variables
	.const MaxKeyRollover = 3

SCNKEY:

	lda #$00
	sta BufferQuantity

	// Decrement key repeat timeout if non-zero
	ldx KOUNT
	beq sk_start
	dec KOUNT
	
sk_start:	
	// Call main keyboard scanning routine
	jsr Main

	lda BufferQuantity
	beq no_keys_waiting
	
	// Stuff each key pressed into the keyboard buffer

	ldy #$00
!:
	lda Buffer,y
	jsr accept_key
	iny
	cpy BufferQuantity
	bne !-
no_keys_waiting:
	
	rts

accept_key:	
	// Work out what is new and needs to be added
	// to the input buffer.
	// Also update the bucky key status flags etc
	cmp #$ff
	beq sk_nokey
	// Got a key, turn it from matrix position to key value,
	// and stuff it in the keyboard buffer

	// Convert matrix position to key code
	// XXX - Add offset of $40, $80 or $C0 if shift, CONTROL or C= are held down
	pha
	lda SHFLAG
	and #$7
	tax
	pla
	and #$3f
	ora kb_matrix_lookup,x
	tax
	lda kb_matrix,x
	// But don't insert $00 characters
	beq sk_nokey

	// Stash key into keyboard buffer
	ldx NDX
	cpx XMAX
	beq sk_nokey
	sta KEYD,x
	inc NDX

sk_nokey:

	rts

	// //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	// // Routine for Scanning a Matrix Row

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


	// //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	// // Routine for handling: Key Found

KeyFound:
	stx TempZP
	dec KeyQuantity
	bmi OverFlow

	// Originally, we resolved the keys.
	// Now we just return the matrix position, so that
	// we can do C64-style bucky modifications as normal
	// was: ldy KeyTable,x
	pha
	txa

	ldx KeyQuantity
	sta BufferNew,x
	pla
	ldx TempZP
	rts

	// //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	// // Routine for handling: Overflow

OverFlow:
	pla  // Dirty hack to handle 2 layers of JSR
	pla
	pla
	pla
	// Don't manipulate last legal buffer as the routine will fix itself once it gets valid input again.

ReturnNoKeys:
	sec
	lda #$00
	sta BufferQuantity
	lda #$FF
	sta LSTX
	ldx #MaxKeyRollover-1
!:
	sta Buffer,x
	sta BufferOld,x
	dex
	bpl !-

	rts


	// //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	// // Exit Routine for: No Activity

NoActivityDetected:

	// So cancel all bucky keys
	lda SHFLAG
	sta LSTSHF
	lda #$00
	sta SHFLAG
	
	jmp ReturnNoKeys

	// //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	// // Configure Data Direction Registers
Main:
	// Begin with no key events
	lda #$ff
	sta BufferNew+0
	sta BufferNew+1
	sta BufferNew+2

	// //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	// // Check for Port Activity

	ldx #$FF
	ldy #$00

	sty CIA1_PRA       // Connect all Keyboard Rows
	cpx CIA1_PRB
	bne skip0

	jmp NoActivityDetected

JoystickActivity:

	// Clear bucky key status
	lda #$00
	sta SHFLAG
	
	lda CIA1_PRB
	and #$03
	cmp #$01
	bne !+
	// down
	ldx #$07       		// UP/DOWN
	jsr KeyFound
!:
	cmp #$02
	bne !+
	// Up
	// Mark shift as pressed
	ldx #$01
	stx SHFLAG
	ldx #$07		// UP/DOWN
	jsr KeyFound
!:
	//  Only allow up/down OR left/right, since
	// else we have confusing situation with SHIFT required
	// for one, but not the other.
	// XXX - We could fix this by making the joystick activity
	// feed the key input at a higher level, rather than
	// simulating directly pressing the cursor keys.
	cmp #$03
	beq !+
	jmp skdone
!:
	lda CIA1_PRB
	and #$0c
	cmp #$04
	bne !+
	ldx #$02
	jsr KeyFound		// LEFT/RIGHT
!:
	cmp #$08
	bne !+
	ldx #$01
	stx SHFLAG
	ldx #$02
	jsr KeyFound		// LEFT/RIGHT
!:
	jmp skdone


skip0:

	// // Set max keys allowed before ignoring result
	lda #MaxKeyRollover
	sta KeyQuantity

	// //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	// // Check for Control Port #1 Activity

	stx CIA1_PRA    // Disconnect all Keyboard Rows
	cpx CIA1_PRB    // Only Control Port activity will be detected
	bne JoystickActivity

	// //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	// // Scan Keyboard Matrix

	ldx #7
	lda #%11111110
next_row:	
	sta CIA1_PRA
	pha
	lda CIA1_PRB
	sta ScanResult,x
	pla
	sec
	rol
	dex
	bpl next_row

	// X gets back to $FF here, which is assumed below

	// //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	// // Check for Control Port #1 Activity (again)

	stx CIA1_PRA    // Disconnect all Keyboard Rows
	cpx CIA1_PRB    // Only Control Port activity will be detected
	beq !+
	jmp ReturnNoKeys
!:
	// Make X = $00, assumed below
	inx

	// //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	// // Check and flag Non Alphanumeric Keys

	// Store de-bounce data for bucky keys
	// (Compute's Mapping the 64, p58-59)
	lda SHFLAG
	sta LSTSHF

	// Build bucky state
	lda #$00
	sta SHFLAG
	lda ScanResult+6
	eor #%10000000
	and #%10000000     // Left shift
	rol
	rol
	and #$01
	ora SHFLAG
	sta SHFLAG

	// Right shift
	lda ScanResult+1
	eor #$10
	lsr
	lsr
	lsr
	lsr
	and #$01
	ora SHFLAG
	sta SHFLAG
	
	// Control
	lda ScanResult+0
	eor #$04
	and #$04
	ora SHFLAG
	sta SHFLAG

	// Vendor key
	lda ScanResult+0
	eor #$ff
	lsr
	lsr
	lsr
	lsr
	and #$02
	ora SHFLAG
	sta SHFLAG

	// Handle SHIFT + VENDOR
	jsr scnkey_toggle_if_needed

no_case_toggle:	
	
	// //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	// // Check for pressed key(s)

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



	// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	// Key Scan Completed

	// Put any new key (not in old scan) into buffer
    ldx #MaxKeyRollover-1

ProcessPressedKeys:	

	// Check if the currently pressed key is continuing to be held down
	lda BufferNew,x
    cmp #$ff
    beq ConsiderNextKey
    cmp BufferOld
    beq KeyHeld
    cmp BufferOld+1
    beq KeyHeld
    cmp BufferOld+2	
    beq KeyHeld

RecordKeypress:

    // New Key Detected
	ldy BufferQuantity
	cpy #MaxKeyRollover
	bcc !+
	jmp ReturnNoKeys // too many new keys
!:
AcceptKeyEvent:	
    sta Buffer,y
	iny
	sty BufferQuantity

ConsiderNextKey:
    dex
    bpl ProcessPressedKeys

	// Copy new presses to old list
	ldx #MaxKeyRollover-1
!:
	lda BufferNew,x
	sta BufferOld,x
	dex
	bpl !-
	
	// Return success and set of pressed keys
	clc
	rts

KeyHeld:
	// The key in A is still held down.
	// compare with key in LSTX
	// (Compute's Mapping the 64 p36-37)
	// if different, reset repeat count down.

	// Ignore bucky keys, so that repeat can work when a
	// bucky is held down.
	cmp #15
	beq BuckyHeld
	cmp #52
	beq BuckyHeld
	cmp #58
	beq BuckyHeld
	cmp #61
	beq BuckyHeld

	cmp LSTX
	beq SameKeyHeld

	// Different key held
	sta LSTX
	pha
	lda DELAY
	sta KOUNT
	pla
BuckyHeld:
	jmp ConsiderNextKey
	
SameKeyHeld:
	pha
	lda KOUNT
	bmi KeyCanRepeat
	bne KeyRepeatWait
	// Count down ended, so repeat key now
KeyCanRepeat:	

	// (Compute's Mapping the 64 p58)
	pha
	lda #6-2  		// Fudge factor to match speed
	sta KOUNT
	pla
	pla
	
	jmp RecordKeypress
KeyRepeatWait:
	pla
	jmp ConsiderNextKey


#endif // CONFIG_LEGACY_SCNKEY
