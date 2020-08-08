// #LAYOUT# M65 KERNAL_0 #TAKE
// #LAYOUT# *   *        #IGNORE


M65_MODE64:

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

	jmp M65_SLOW
