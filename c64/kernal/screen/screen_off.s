// #LAYOUT# STD *        #TAKE
// #LAYOUT# X16 *        #IGNORE
// #LAYOUT# *   KERNAL_0 #TAKE
// #LAYOUT# *   *        #IGNORE

//
// Helper routine to blank screen
//


#if CONFIG_TAPE_NORMAL || CONFIG_TAPE_TURBO || (CONFIG_IEC_JIFFYDOS && !CONFIG_MEMORY_MODEL_60K)


screen_off:

	lda VIC_SCROLY
	and #($FF - $10)
	sta VIC_SCROLY

	// To be sure there are no badlines we have to wait till the next screen,
	// as the bit is checked by VIC-II at the start of the frame only
!:
	lda VIC_SCROLY                     // wait for higher part of screen
	bpl !-
!:
	lda VIC_SCROLY                     // wait for lower part of the screen
	bmi !-

	rts


#endif
