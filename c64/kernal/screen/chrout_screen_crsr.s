
//
// Cursor keys handling within CHROUT
//


chrout_screen_CRSR_UP:

	lda PNTR
	sec
	sbc #40
	sta PNTR
	jmp chrout_screen_calc_lptr_done

chrout_screen_CRSR_DOWN:

	lda PNTR
	clc
	adc #40
	sta PNTR
	// We need to advance the pointer manually, as normalising
	// now will break things. The pointer update is required
	// so that we can tell if we really are on the bottom phys
	// screen line or not
	jsr screen_scroll_up_if_on_last_line
	jmp chrout_screen_calc_lptr_done

chrout_screen_CRSR_LEFT:

	lda TBLX
	ora PNTR
	beq !+ // recalculating pointer is not really necessary, but this is a very rare case nevertheless
	dec PNTR
!:
	jmp chrout_screen_calc_lptr_done

chrout_screen_CRSR_RIGHT:

	inc PNTR
	jmp chrout_screen_calc_lptr_done
