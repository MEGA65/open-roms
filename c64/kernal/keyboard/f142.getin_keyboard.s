// #LAYOUT# STD *        #TAKE
// #LAYOUT# *   KERNAL_0 #TAKE
// #LAYOUT# *   *        #IGNORE

//
// Well-known Kernal routine, described in:
//
// - http://sta.c64.org/cbm64kbdfunc.html
//


getin_keyboard: // XXX confirm that here is really a part of GETIN!

	// Check for a key
	lda NDX
	bne !+

	// Nothing in keyboard buffer to read
	sec
	rts
	
!:
	lda KEYD
	pha
	phy_trash_a

	jsr pop_keyboard_buffer

	ply_trash_a
	pla
	clc

	rts
