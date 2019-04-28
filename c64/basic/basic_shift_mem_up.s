

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
	sbc basic_current_line_ptr+0
	sta memmove_size+0	
	
	jsr printf
	.byte "TOP OF BASIC = $"
	.byte $f1,<basic_end_of_text_ptr,>basic_end_of_text_ptr
	.byte $f0,<basic_end_of_text_ptr,>basic_end_of_text_ptr
	.byte $0d
	.byte "SHIFTING UP $"
	.byte $f1,<memmove_size,>memmove_size
	.byte $f0,<memmove_size,>memmove_size
	.byte " BYTES FROM $"
	.byte $f1,<memmove_src,>memmove_src
	.byte $f0,<memmove_src,>memmove_src
	.byte " TO $"
	.byte $f1,<memmove_dst,>memmove_dst
	.byte $f0,<memmove_dst,>memmove_dst
	.byte $0d,0
	
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

	stx tokenise_work3
	
	jsr printf
	.byte "REVISED BOUNDS $"
	.byte $f1,<memmove_size,>memmove_size
	.byte $f0,<memmove_size,>memmove_size
	.byte " BYTES FROM $"
	.byte $f1,<memmove_src,>memmove_src
	.byte $f0,<memmove_src,>memmove_src
	.byte " TO $"
	.byte $f1,<memmove_dst,>memmove_dst
	.byte $f0,<memmove_dst,>memmove_dst
	.byte $0d,0
	
	;; Do the copy
	jsr shift_mem_up
	
	;; Now fix the pointer to the next line
	
	;; First, we need to point the current BASIC line
	;; pointer to itself, so that we can add the shift
	;; to make it end up pointing to the next line
	ldy #0
	ldx #<basic_current_line_ptr+0
	lda basic_current_line_ptr+0
	jsr poke_under_roms
	iny
	lda basic_current_line_ptr+1
	jsr poke_under_roms
	
relink_up_next_line:
	;; inc $d020
	;; jmp relink_up_next_line
	
	ldy #0
	ldx #<basic_current_line_ptr+0
	jsr peek_under_roms
	clc
	adc tokenise_work3
	sta memmove_src+0
	iny
	jsr peek_under_roms
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
