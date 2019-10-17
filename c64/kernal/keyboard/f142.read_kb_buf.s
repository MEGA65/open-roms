
//
// Well-known Kernal routine, described in:
//
// - http://sta.c64.org/cbm64kbdfunc.html
//


read_kb_buf:

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
