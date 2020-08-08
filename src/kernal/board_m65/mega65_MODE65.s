// #LAYOUT# M65 KERNAL_0 #TAKE
// #LAYOUT# *   *        #IGNORE


M65_MODE65:

	// Disable interrupts, they might interfere

	sei

	// Switch CPU speed to fast

	jsr M65_FAST

	// Set the magic string to mark native mode

	lda #$4D // 'M'
	sta M65_MAGICSTR+0
	lda #$36 // '6'
	sta M65_MAGICSTR+1
	lda #$35 // '5'
	sta M65_MAGICSTR+2

	// XXX provide full implementation

	// Switch VIC to VIC-IV mode

	jsr viciv_unhide

	// XXX provide proper implementation below

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
