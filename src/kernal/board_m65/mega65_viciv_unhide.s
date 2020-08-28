// #LAYOUT# M65 KERNAL_0 #TAKE
// #LAYOUT# *   *        #IGNORE

//
// Routine to unhide MEGA65 extra registers
//


viciv_unhide:

	lda #$47
	sta VIC_KEY
	lda #$53
	sta VIC_KEY

	rts
