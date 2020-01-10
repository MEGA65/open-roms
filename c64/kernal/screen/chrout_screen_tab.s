#if ROM_LAYOUT_STD || (ROM_LAYOUT_M65 && SEGMENT_KERNAL_0)

//
// Tabulation keys handling within CHROUT
//


#if CONFIG_EDIT_TABULATORS


chrout_screen_TAB_FW:

	jsr screen_get_clipped_PNTR
	tya
	ora #%00000111
	tay
	iny
	cpy #40
	bcc !+
	ldy #39
!:
	sty PNTR
	
	jmp chrout_screen_calc_lptr_done


chrout_screen_TAB_BW:

	jsr screen_get_clipped_PNTR
	beq !+                             // column 0,  recalculating pointers is not necessary, but this is a rare case nevertheless

	dey
	tya
	and #%11111000
	sta PNTR
!:
	jmp chrout_screen_calc_lptr_done


#endif // CONFIG_EDIT_TABULATORS


#endif // ROM layout
