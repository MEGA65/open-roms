
//
// Helper routines to blank/show screen
//


#if CONFIG_TAPE_NORMAL || CONFIG_TAPE_TURBO


screen_blank:

	lda VIC_SCROLY
	and #($FF - $10)
	sta VIC_SCROLY

	rts


screen_show:

	lda VIC_SCROLY
	ora #$10
	sta VIC_SCROLY

	rts


#endif
