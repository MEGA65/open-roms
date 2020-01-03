
//
// CHROUT routine - screen support, DEL key handling
//

chrout_screen_DEL:
	jmp chrout_screen_done

/* YYY disabled for rework
chrout_screen_DEL:

	// In insert mode it embeds control character
	ldx INSRT
	beq !+
	jmp chrout_screen_quote
!:
	ldx PNTR
	bne chrout_screen_del_column_non_0

	// FALLTROUGH

chrout_screen_del_column_0:

	ldy TBLX
	beq chrout_screen_del_done // delete from row 0, col 0 does nothing

	// Column 0 delete just moves us to the end of the
	// previous line, without actually deleting anything

	dec TBLX
	jsr screen_get_current_line_logical_length
	lda LNMX
	sta PNTR

	jmp chrout_screen_calc_lptr_done

chrout_screen_del_column_non_0:

	// Copy rest of line down
	jsr screen_get_current_line_logical_length
	ldy PNTR
	cpy LNMX
	beq !++
	dey
!:
	iny
	lda (PNT),y
	dey
	sta (PNT),y
	iny
	lda (USER),y
	dey
	sta (USER),y
	iny
	cpy LNMX
	bne !-

	// Clear char at end of line
	jsr screen_get_current_line_logical_length
	tay
	lda #$20
	sta (PNT),y
!:
	dec PNTR

	// FALLTROUGH

chrout_screen_del_done:
	jmp chrout_screen_done

*/