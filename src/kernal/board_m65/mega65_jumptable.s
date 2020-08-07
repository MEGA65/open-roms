// #LAYOUT# M65 KERNAL_0 #TAKE
// #LAYOUT# *   *        #IGNORE

//
// Not this is not an official Kernal API extension (yet)! It is subject to change!
//


M65_JMODE64:

	// Disable interrupts, they might interfere

	sei

	// XXX provide full implementation

	// Set the magic string to mark legacy mode

	lda #$00
	sta M65_MAGICSTR+0
	sta M65_MAGICSTR+1
	sta M65_MAGICSTR+2

	// Reenable interrupts

	cli

	// Switch CPU speed back to slow and quit

	jmp M65_JSLOW



M65_JMODE65:

	// Disable interrupts, they might interfere

	sei

	// Swithc CPU speed to fast

	jsr M65_JFAST

	// Set the magic string to mark native mode

	lda #$4D // 'M'
	sta M65_MAGICSTR+0
	lda #$36 // '6'
	sta M65_MAGICSTR+1
	lda #$35 // '5'
	sta M65_MAGICSTR+2

	// XXX provide full implementation

	// Switch VIC to VIC-IV mode

	lda #$47
	sta VIC_KEY
	lda #$53
	sta VIC_KEY

	// XXX provide proper implementation

	// Set screen mode to 80 columns

	lda $D031
	ora #$80
	sta $D031

	// Set screen RAM base to $15000

	lda #$00
	sta $D060
	sta LDTB1+0
	sta $D063
	sta LDTB1+3
	lda #$50
	sta $D061
	sta LDTB1+1
	lda #$01
	sta $D062
	sta LDTB1+2

	// Set something in screen memory

	lda #$01

	// STA [],Z
	nop
	.byte $92
	.byte LDTB1

!:
	nop
	jmp !-



M65_JISMODE65: // checks if mode is native M65 one, BEQ = jump if native mode

	pha

	lda M65_MAGICSTR+0
	cmp #$4D // 'M'
	bne !+
	lda M65_MAGICSTR+1
	cmp #$36 // '6'
	bne !+
	lda M65_MAGICSTR+2
	cmp #$35 // '5'
!:
	pla
	rts




M65_JSLOW: // set CPU speed to 1 MHz

	lda #$40
	skip_2_bytes_trash_nvz

	// FALLTROUGH

M65_JFAST: // set CPU speed to 40 MHz

	lda #$41
	sta CPU_D6510
	rts
