
//
// CHROUT routine - screen support, DEL key handling
//


chrout_screen_DEL:

	// In insert mode it embeds control character
	ldx INSRT
	beq !+
	jmp chrout_screen_quote
!:
	ldy PNTR
	bne chrout_screen_del_column_normal

	// FALLTROUGH

chrout_screen_del_column_0:

	ldy TBLX
	beq chrout_screen_del_done         // delete from row 0, col 0 does nothing

	// Move cursor to end of previous line
	dec TBLX
	lda #39
	sta PNTR
	
	// Update PNT and USER pointers
	jsr screen_calculate_PNT_USER

	// Put space character at the current cursor position (do not clear the color!)
	ldy #39
	lda #$20
	sta (PNT),y

	// Finish with recalculating all the variables
	bne chrout_screen_del_done

chrout_screen_del_column_normal:

	// We need to scroll back the rest of the logical line

	// First reduce PNTR to 0-39 range
	jsr screen_get_clipped_PNTR
	sty PNTR

	// Now get the offset to the last logical line character
	jsr screen_get_logical_line_end_ptr
	tya

	// Substract the PNTR value, this will tell us how many characters we need to move
	sec
	sbc PNTR
	tax

	// Perform the character copy (scroll back) in a loop
	ldy PNTR
	dey
!:
	iny
	lda (USER),y
	dey
	sta (USER),y
	iny
	lda (PNT),y
	dey
	sta (PNT),y
	iny

	dex
	bpl !-

	// Clear char at end of line (just the character - not color!)

	jsr screen_get_logical_line_end_ptr
	lda #$20
	sta (PNT),y
	dec PNTR

	// FALLTROUGH

chrout_screen_del_done:

	jmp chrout_screen_calc_lptr_done
