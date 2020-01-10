#if ROM_LAYOUT_STD || (ROM_LAYOUT_M65 && SEGMENT_KERNAL_0)

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


#endif // ROM layout
