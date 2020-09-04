// #LAYOUT# M65 KERNAL_0 #TAKE
// #LAYOUT# *   *        #IGNORE

//
// Routine to shutdown VIC-IV for leaving MEGA65 native mode
//


viciv_shutdown:

	// Switch VIC to VIC-IV mode, temporarily

	jsr viciv_unhide

	// Reenable badlines and slow interrupt emulation

	lda #$03
	sta MISC_EMU

	// Set misc VIC-IV flags

	lda #%00000000
	sta VIC_CTRLA  // enable C64 character set
	sta VIC_CTRLB  // disable extended resolution and attributes

	// Reenable hot registers

	jsr viciv_hotregs_on

	// Hide VIC-IV registers and quit

	sta VIC_KEY
	rts
