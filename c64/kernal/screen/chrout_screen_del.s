
//
// CHROUT routine - screen support, DEL key handling
//


chrout_screen_DEL:

	// In insert mode it embeds control character
	ldx INSRT
	beq !+
	jmp chrout_screen_quote
!:
	// ldx PNTR
	jsr screen_get_clipped_PNTR
	cpy #$00
	bne chrout_screen_del_column_non_0

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

	// Put space character at the current cursor position
	ldy #39
	lda #$20
	sta (PNT),y
	
	// XXX should we clear the color too?

	// Finish with recalculating all the variables
	jmp chrout_screen_calc_lptr_done

chrout_screen_del_column_non_0:

/* YYY disabled for rework

	// Copy rest of logical line back 
	jsr screen_get_logical_line_end_ptr
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

*/

chrout_screen_del_done:

	jmp chrout_screen_done
