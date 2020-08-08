// #LAYOUT# M65 KERNAL_1 #TAKE
// #LAYOUT# *   *        #IGNORE


M65_MODE64:

	// Disable interrupts, they might interfere

	sei

	// XXX provide full implementation - switch back to normal text mode

	// Set the magic string to mark legacy mode

	lda #$00
	sta M65_MAGICSTR+0
	sta M65_MAGICSTR+1
	sta M65_MAGICSTR+2

	// Reenable badlines and slow interrupt emulation

	lda #$03
	sta MISC_EMU

	// Set misc VIC-IV flags

	lda %00000000  // enable C64 character set
	sta VIC_CTRLA

	// Switch to VIC-II mode

	sta VIC_KEY

	// Reenable interrupts

	cli

	// Switch CPU speed back to slow and quit

	jmp M65_SLOW
