#if ROM_LAYOUT_STD || (ROM_LAYOUT_M65 && SEGMENT_KERNAL_0)

//
// Cursor keys handling within CHROUT
//


chrout_screen_CRSR_UP:

	lda TBLX
	beq chrout_screen_CRSR_done
	dec TBLX

	// FALLTROUGH

chrout_screen_CRSR_done:

	jmp chrout_screen_calc_lptr_done


chrout_screen_CRSR_DOWN:

	lda TBLX
	cmp #24
	bne !+
	jsr screen_scroll_up
!:
	inc TBLX
	jmp chrout_screen_calc_lptr_done


chrout_screen_CRSR_RIGHT:

	jsr screen_get_clipped_PNTR
	cpy #39
	beq_16 screen_advance_to_next_line
	
	iny
!:
	sty PNTR
	bpl chrout_screen_CRSR_done        // branch always


chrout_screen_CRSR_LEFT:

	jsr screen_get_clipped_PNTR
	dey
	bpl !-

	lda TBLX
	beq chrout_screen_CRSR_done

	dec TBLX
	lda #39
	sta PNTR
	bne chrout_screen_CRSR_done        // branch always


#endif // ROM layout
