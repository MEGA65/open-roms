// #LAYOUT# M65 KERNAL_0 #TAKE
// #LAYOUT# *   *        #IGNORE

//
// Routine to initialize VIC-IV for entering MEGA65 native mode
//


viciv_init:

	// Switch VIC to VIC-IV mode

	jsr viciv_unhide

	// Disable badlines and slow interrupt emulation

	lda #$00
	sta MISC_EMU

	// Set misc VIC-IV flags

	lda #%01000000  // enable C65 character set
	sta VIC_CTRLA

	// XXX enable 48 MHz mode in VIC_CTRLC

	rts
