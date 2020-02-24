// #LAYOUT# STD *        #TAKE
// #LAYOUT# X16 *        #IGNORE
// #LAYOUT# *   KERNAL_0 #TAKE
// #LAYOUT# *   *        #IGNORE

//
// Helper routine to show screen
//


#if CONFIG_TAPE_NORMAL || CONFIG_TAPE_TURBO


screen_on:

	lda VIC_SCROLY
	ora #$10
	sta VIC_SCROLY

	rts

#endif
