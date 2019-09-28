

basic_shift_mem_up_and_relink:
	// Shift memory up from basic_current_line_ptr
	// X bytes.

	// NOTE: Pointers need to be reduced by one, due to the way
	// the copyroutine works, so we do that here.
	// Work out end point of destination
	txa
	clc
	adc basic_end_of_text_ptr+0
	sta __memmove_dst+0
	lda basic_end_of_text_ptr+1
	adc #0
	sta __memmove_dst+1
	lda __memmove_dst+0
	sec
	sbc #1
	sta __memmove_dst+0
	lda __memmove_dst+1
	sbc #0
	sta __memmove_dst+1

	// End point of source is just current end of BASIC text
	lda basic_end_of_text_ptr+0
	sec
	sbc #1
	sta __memmove_src+0
	lda basic_end_of_text_ptr+1
	sbc #0
	sta __memmove_src+1

	// Work out size of region to copy
	lda basic_end_of_text_ptr+0
	sec
	sbc basic_current_line_ptr+0
	sta __memmove_size+0	
	lda basic_end_of_text_ptr+1
	sbc basic_current_line_ptr+1
	sta __memmove_size+1
	
	// jsr printf
	// .text "TOP OF BASIC = $"
	// .byte $f1,<basic_end_of_text_ptr,>basic_end_of_text_ptr
	// .byte $f0,<basic_end_of_text_ptr,>basic_end_of_text_ptr
	// .byte $0d
	// .text "SHIFTING UP $"
	// .byte $f1,<__memmove_size,>__memmove_size
	// .byte $f0,<__memmove_size,>__memmove_size
	// .text " BYTES FROM $"
	// .byte $f1,<__memmove_src,>__memmove_src
	// .byte $f0,<__memmove_src,>__memmove_src
	// .text " TO $"
	// .byte $f1,<__memmove_dst,>__memmove_dst
	// .byte $f0,<__memmove_dst,>__memmove_dst
	// .byte $0d,0
	
	// To make life simple for the copy routine that lives in RAM,
	// we have to adjust the end pointers down one page and set Y to the low
	// byte of the copy size.
	lda __memmove_src+0
	sec
	sbc __memmove_size+0
	sta __memmove_src+0
	lda __memmove_src+1
	sbc #0
	sta __memmove_src+1

	lda __memmove_dst+0
	sec
	sbc __memmove_size+0
	sta __memmove_dst+0
	lda __memmove_dst+1
	sbc #0
	sta __memmove_dst+1

	// Now make exit easy, by being able to check for zero on size high byte when done
	inc __memmove_size+1	
	
	// Then set Y to the number offset required
	ldy __memmove_size+0
	iny

	stx __tokenise_work3
	
	// jsr printf
	// .text "REVISED BOUNDS $"
	// .byte $f1,<__memmove_size,>__memmove_size
	// .byte $f0,<__memmove_size,>__memmove_size
	// .text " BYTES FROM $"
	// .byte $f1,<__memmove_src,>__memmove_src
	// .byte $f0,<__memmove_src,>__memmove_src
	// .text " TO $"
	// .byte $f1,<__memmove_dst,>__memmove_dst
	// .byte $f0,<__memmove_dst,>__memmove_dst
	// .byte $0d,0
	
	// Do the copy
	jsr shift_mem_up
	
	// Now fix the pointer to the next line
	
	// First, we need to point the current BASIC line
	// pointer to itself, so that we can add the shift
	// to make it end up pointing to the next line
	ldy #0

	lda basic_current_line_ptr+0

#if CONFIG_MEMORY_MODEL_60K
	ldx #<basic_current_line_ptr+0
	jsr poke_under_roms
#else // CONFIG_MEMORY_MODEL_38K
	sta (basic_current_line_ptr),y
#endif

	iny
	lda basic_current_line_ptr+1

#if CONFIG_MEMORY_MODEL_60K
	jsr poke_under_roms
#else // CONFIG_MEMORY_MODEL_38K
	sta (basic_current_line_ptr),y
#endif
	
relink_up_next_line:
	// inc $d020
	// jmp relink_up_next_line
	
	// Advance pointer by tokenise_word3 bytes
	ldy #0

#if CONFIG_MEMORY_MODEL_60K
	ldx #<basic_current_line_ptr+0
	jsr peek_under_roms
#else // CONFIG_MEMORY_MODEL_38K
	lda (basic_current_line_ptr),y
#endif

	sta __memmove_dst+0
	clc
	adc __tokenise_work3
	sta __memmove_src+0
	iny
	php

#if CONFIG_MEMORY_MODEL_60K
	jsr peek_under_roms
	cmp #$00
#else // CONFIG_MEMORY_MODEL_38K
	lda (basic_current_line_ptr),y
#endif

	sta __memmove_dst+1
	plp
	adc #0
	sta __memmove_src+1

	// jsr printf
	// .text "LINE ADDR = $"
	// .byte $f1,<basic_current_line_ptr,>basic_end_of_text_ptr
	// .byte $f0,<basic_current_line_ptr,>basic_end_of_text_ptr
	// .text $d,"  BEFORE = $"
	// .byte $f1,<__memmove_dst,>__memmove_dst
	// .byte $f0,<__memmove_dst,>__memmove_dst
	// .text ",  AFTER = $"
	// .byte $f1,<__memmove_src,>__memmove_src
	// .byte $f0,<__memmove_src,>__memmove_src
	// .byte $d
	// .byte 0
	
	// Write __memmove_src back to current line pointer
	ldy #0
	lda __memmove_src+0

#if CONFIG_MEMORY_MODEL_60K
	ldx #<basic_current_line_ptr+0
	jsr poke_under_roms
#else // CONFIG_MEMORY_MODEL_38K
	sta (basic_current_line_ptr),y
#endif

	iny
	lda __memmove_src+1

#if CONFIG_MEMORY_MODEL_60K
	jsr poke_under_roms
#else // CONFIG_MEMORY_MODEL_38K
	sta (basic_current_line_ptr),y
#endif
	
relink_up_loop:	
	// Now advance pointer to the next line,
	lda __memmove_src+0
	sta basic_current_line_ptr+0
	lda __memmove_src+1
	sta basic_current_line_ptr+1

	// Have we run out of lines to patch?
	jsr peek_line_pointer_null_check
	bcs relink_up_next_line

	rts
