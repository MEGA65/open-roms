
//
// Tabulation keys handling within CHROUT
//


#if CONFIG_EDIT_TABULATORS

chrout_screen_TAB_FW:
	rts
chrout_screen_TAB_BW:
	rts

/* YYY disabled for rework
chrout_screen_TAB_FW:

	lda PNTR
	ora #%00000111
	sta PNTR
	inc PNTR
	jmp chrout_screen_calc_lptr_done


chrout_screen_TAB_BW:

	lda TBLX
	ora PNTR
	beq !+ // top-left corner, recalculating pointer is not necessary, but this is a very rare case nevertheless

	dec PNTR
	lda PNTR
	and #%11111000
	sta PNTR
!:
	jmp chrout_screen_calc_lptr_done */


#endif // CONFIG_EDIT_TABULATORS
