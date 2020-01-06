
//
// Cursor keys handling within CHROUT
//


chrout_screen_CRSR_UP:

	lda TBLX
	beq !+
	dec TBLX
!:
	jmp chrout_screen_calc_lptr_done


chrout_screen_CRSR_DOWN:

	lda TBLX
	cmp #24
	bne !+

	jsr screen_scroll_up_delay_done
!:
	inc TBLX
	jmp chrout_screen_calc_lptr_done




chrout_screen_CRSR_LEFT:
	jmp chrout_screen_calc_lptr_done
chrout_screen_CRSR_RIGHT:
	jmp chrout_screen_calc_lptr_done

/* YYY disabled for rework

chrout_screen_CRSR_LEFT:

	lda TBLX
	ora PNTR
	beq !+ // top-left corner, recalculating pointer is not necessary, but this is a very rare case nevertheless
	dec PNTR
!:
	jmp chrout_screen_calc_lptr_done


chrout_screen_CRSR_RIGHT:

	inc PNTR
	jmp chrout_screen_calc_lptr_done

*/
