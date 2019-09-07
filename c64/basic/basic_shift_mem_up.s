

basic_shift_mem_up_and_relink:
	// Shift memory up from basic_current_line_ptr
	// X bytes.

	// NOTE: Pointers need to be reduced by one, due to the way
	// the copyroutine works, so we do that here.
	// Work out end point of destination
	txa
	clc
	adc basic_end_of_text_ptr+0
	sta memmove_dst+0
	lda basic_end_of_text_ptr+1
	adc #0
	sta memmove_dst+1
	lda memmove_dst+0
	sec
	sbc #1
	sta memmove_dst+0
	lda memmove_dst+1
	sbc #0
	sta memmove_dst+1

	// End point of source is just current end of BASIC text
	lda basic_end_of_text_ptr+0
	sec
	sbc #1
	sta memmove_src+0
	lda basic_end_of_text_ptr+1
	sbc #0
	sta memmove_src+1

	// Work out size of region to copy
	lda basic_end_of_text_ptr+0
	sec
	sbc basic_current_line_ptr+0
	sta memmove_size+0	
	lda basic_end_of_text_ptr+1
	sbc basic_current_line_ptr+1
	sta memmove_size+1
	
	// jsr printf
	// .text "TOP OF BASIC = $"
	// .byte $f1,<basic_end_of_text_ptr,>basic_end_of_text_ptr
	// .byte $f0,<basic_end_of_text_ptr,>basic_end_of_text_ptr
	// .byte $0d
	// .text "SHIFTING UP $"
	// .byte $f1,<memmove_size,>memmove_size
	// .byte $f0,<memmove_size,>memmove_size
	// .text " BYTES FROM $"
	// .byte $f1,<memmove_src,>memmove_src
	// .byte $f0,<memmove_src,>memmove_src
	// .text " TO $"
	// .byte $f1,<memmove_dst,>memmove_dst
	// .byte $f0,<memmove_dst,>memmove_dst
	// .byte $0d,0
	
	// To make life simple for the copy routine that lives in RAM,
	// we have to adjust the end pointers down one page and set Y to the low
	// byte of the copy size.
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

	// Now make exit easy, by being able to check for zero on size high byte when done
	inc memmove_size+1	
	
	// Then set Y to the number offset required
	ldy memmove_size+0
	iny

	stx tokenise_work3
	
	// jsr printf
	// .text "REVISED BOUNDS $"
	// .byte $f1,<memmove_size,>memmove_size
	// .byte $f0,<memmove_size,>memmove_size
	// .text " BYTES FROM $"
	// .byte $f1,<memmove_src,>memmove_src
	// .byte $f0,<memmove_src,>memmove_src
	// .text " TO $"
	// .byte $f1,<memmove_dst,>memmove_dst
	// .byte $f0,<memmove_dst,>memmove_dst
	// .byte $0d,0
	
	// Do the copy
	jsr shift_mem_up
	
	// Now fix the pointer to the next line
	
	// First, we need to point the current BASIC line
	// pointer to itself, so that we can add the shift
	// to make it end up pointing to the next line
	ldy #0
	ldx #<basic_current_line_ptr+0
	lda basic_current_line_ptr+0
	jsr poke_under_roms
	iny
	lda basic_current_line_ptr+1
	jsr poke_under_roms
	
relink_up_next_line:
	// inc $d020
	// jmp relink_up_next_line
	
	// Advance pointer by tokenise_word3 bytes
	ldy #0
	ldx #<basic_current_line_ptr+0
	jsr peek_under_roms
	sta memmove_dst+0
	clc
	adc tokenise_work3
	sta memmove_src+0
	iny
	php
	jsr peek_under_roms
	sta memmove_dst+1
	plp
	adc #0
	sta memmove_src+1

	// jsr printf
	// .text "LINE ADDR = $"
	// .byte $f1,<basic_current_line_ptr,>basic_end_of_text_ptr
	// .byte $f0,<basic_current_line_ptr,>basic_end_of_text_ptr
	// .text $d,"  BEFORE = $"
	// .byte $f1,<memmove_dst,>memmove_dst
	// .byte $f0,<memmove_dst,>memmove_dst	
	// .text ",  AFTER = $"
	// .byte $f1,<memmove_src,>memmove_src
	// .byte $f0,<memmove_src,>memmove_src
	// .byte $d
	// .byte 0
	
	// Write memmove_src back to current line pointer
	ldy #0
	ldx #<basic_current_line_ptr
	lda memmove_src+0
	jsr poke_under_roms
	iny
	lda memmove_src+1
	jsr poke_under_roms

	
relink_up_loop:	
	// Now advance pointer to the next line,
	lda memmove_src+0
	sta basic_current_line_ptr+0
	lda memmove_src+1
	sta basic_current_line_ptr+1

	// Have we run out of lines to patch?
	ldx #<basic_current_line_ptr
	jsr peek_pointer_null_check
	bcs relink_up_next_line

	rts
