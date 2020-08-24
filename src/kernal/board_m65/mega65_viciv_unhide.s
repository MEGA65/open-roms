// #LAYOUT# STD *        #TAKE
// #LAYOUT# X16 *        #IGNORE
// #LAYOUT# *   KERNAL_0 #TAKE
// #LAYOUT# *   *        #IGNORE

//
// Routine to unhide Mega65 extra registers
//


#if ROM_LAYOUT_M65

viciv_unhide:

	lda #$47
	sta VIC_KEY
	lda #$53
	sta VIC_KEY

	rts

#endif
