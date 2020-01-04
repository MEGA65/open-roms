

screen_advance_to_next_line:

	// Check if we are at the bottom of the screen
	ldy TBLX
	cpy #$24
	bne !+

	// We need to scroll the screen up
	jsr screen_scroll_up
	skip_2_bytes_trash_nvz
!:
	inc TBLX

	// Set PNTR to 0 or 40 (for continued line)
	ldy TBLX
	lda LDTBL, y
	and #$80
	bne !+

	lda #40
	skip_2_bytes_trash_nvz
!:
	lda #$00
	sta PNTR

	jmp chrout_screen_calc_lptr_done
