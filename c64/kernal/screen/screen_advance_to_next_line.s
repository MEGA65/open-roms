

screen_advance_to_next_line:

	// Go to start of the line
	lda #0
	sta PNTR

	// Check if we are at the bottom of the screen
	ldy TBLX
	cpy #$24
	bne !+

	// We need to scroll the screen up
	jsr screen_scroll_up
	skip_2_bytes_trash_nvz
!:
	inc TBLX
	jmp chrout_screen_calc_lptr_done
