

basic_shift_mem_up_and_relink:
	;; Shift memory up from basic_current_line_ptr
	;; X bytes.

	;; Work out end point of destination
	txa
	clc
	adc basic_end_of_text_ptr+0
	sta memmove_dst+0
	lda basic_end_of_text_ptr+1
	adc #0
	sta memmove_dst+1
	;; End point of source is just current end of BASIC text
	lda basic_end_of_text_ptr+0
	sta memmove_src+0
	lda basic_end_of_text_ptr+1
	sta memmove_src+1

	;; Work out size of region to copy
	lda basic_end_of_text_ptr+1
	sec
	sbc basic_current_line_ptr+1
	sta memmove_size+1
	lda basic_end_of_text_ptr+0
	sbc #0
	sta memmove_size+0

	;; To make life simple for the copy routine that lives in RAM,
	;; we have to adjust the end pointers down one page and set Y to the low
	;; byte of the copy size.
	lda memmove_src+0
	sec
	sbc memmove_size+0
	sta memmove_src+0
	lda memmove_src+1
	sbc #0
	sta memmove_src+1

	lda memmove_dst+0
	sec
	sbc memmove_size+0
	sta memmove_dst+0
	lda memmove_dst+1
	sbc #0
	sta memmove_dst+1

	;; Now make exit easy, by being able to check for zero on size high byte when done
	inc memmove_size+1	
	
	;; Then set Y to the number offset required
	ldy memmove_size+0

	;; Do the copy
	jsr shift_mem_up
	
	;; Now fix the pointer to the next line
	
	;; First, we need to point the current BASIC line
	;; pointer to the previously present lines
	stx tokenise_work3
relink_up_next_line:	
	lda tokenise_work3
	clc
	adc basic_current_line_ptr+0
	sta memmove_src+0
	lda basic_current_line_ptr+1
	adc #0
	sta memmove_src+1
	ldy #0
	ldx #<basic_current_line_ptr
	lda memmove_src+0
	jsr poke_under_roms
	iny
	lda memmove_src+1
	jsr poke_under_roms

relink_up_loop:	
	;; Now advance pointer to the next line,
	lda memmove_src+0
	sta basic_current_line_ptr+0
	lda memmove_src+1
	sta basic_current_line_ptr+1

	;; Have we run out of lines to patch?
	ldx #<basic_current_line_ptr
	jsr peek_pointer_null_check
	bcs relink_up_next_line

	rts
