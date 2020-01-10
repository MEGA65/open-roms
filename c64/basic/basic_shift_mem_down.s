#if ROM_LAYOUT_STD || (ROM_LAYOUT_M65 && SEGMENT_BASIC_0)


basic_shift_mem_down_and_relink:
	// Shift memory down to basic_current_line_pointer
	// from X bytes further along.

	// Destination is OLDTXT
	lda OLDTXT+0
	sta __memmove_dst+0
	lda OLDTXT+1
	sta __memmove_dst+1	
	
	// Source is that plus X
	txa
	pha 			// also keep for later
	clc
	adc OLDTXT+0
	sta __memmove_src+0
	lda OLDTXT+1
	adc #0
	sta __memmove_src+1

	// Size is distance from source to end of BASIC text.
	lda VARTAB+0
	sec
	sbc __memmove_src+0
	sta __memmove_size+0
	lda VARTAB+1
	sbc __memmove_src+1
	sta __memmove_size+1

	// jsr printf
	// .text "TOP OF BASIC = $"
	// .byte $f1,<VARTAB,>VARTAB
	// .byte $f0,<VARTAB,>VARTAB
	// .byte $0d
	// .text "SHIFTING DOWN $"
	// .byte $f1,<__memmove_size,>__memmove_size
	// .byte $f0,<__memmove_size,>__memmove_size
	// .text " BYTES FROM $"
	// .byte $f1,<__memmove_src,>__memmove_src
	// .byte $f0,<__memmove_src,>__memmove_src
	// .text " TO $"
	// .byte $f1,<__memmove_dst,>__memmove_dst
	// .byte $f0,<__memmove_dst,>__memmove_dst
	// .byte $0d,0
	
	// The copy routine that copies under the ROMs is as simple
	// as possible to be as small as possible, so we have
	// to adjust the pointers and counts so that the simple
	// increment and decrement bounds checks work.

	// Specifically we want Y pre-set so that the end of the
	// copy ends when Y = $00.
	// So if copying 1 byte, we want Y=$FF
	// This means we have to then reduce the source and
	// target pointers by the same amount

	lda __memmove_size+0
	eor #$ff
	sta __tokenise_work3
	sta __memmove_size+0

	lda __memmove_src+0
	sec
	sbc __tokenise_work3
	sta __memmove_src+0
	lda __memmove_src+1
	sbc #0
	sta __memmove_src+1

	lda __memmove_dst+0
	sec
	sbc __tokenise_work3
	sta __memmove_dst+0
	lda __memmove_dst+1
	sbc #0
	sta __memmove_dst+1

	// Increase copy page count so we can post-decrement compare with $00
	inc __memmove_size+1
	
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

	// Get Y value ready for the copy
	ldy __memmove_size+0
	
	jsr shift_mem_down

	// Get length of deletion back
	pla
	sta __tokenise_work3

	// Check if we still have any lines left
	ldy #0
	jsr peek_line_pointer_null_check
	bcs relink_down_next_line
	// Nope, so just return
	clc
	rts

	
relink_down_next_line:
	// inc $d020
	// jmp relink_down_next_line
	
	// Subtract __tokenise_work3 from the pointer
	ldy #0

#if CONFIG_MEMORY_MODEL_60K
	ldx #<OLDTXT+0
	jsr peek_under_roms
#else // CONFIG_MEMORY_MODEL_38K
	lda (OLDTXT),y
#endif

	sec
	sbc __tokenise_work3
	sta __memmove_src+0
	iny

#if CONFIG_MEMORY_MODEL_60K
	jsr peek_under_roms
#else // CONFIG_MEMORY_MODEL_38K
	lda (OLDTXT),y
#endif

	sbc #0
	sta __memmove_src+1

	ldy #0
	lda __memmove_src+0

#if CONFIG_MEMORY_MODEL_60K
	ldx #<OLDTXT+0
	jsr poke_under_roms
#else // CONFIG_MEMORY_MODEL_38K
	sta (OLDTXT),y
#endif

	iny
	lda __memmove_src+1

#if CONFIG_MEMORY_MODEL_60K
	jsr poke_under_roms
#else // CONFIG_MEMORY_MODEL_38K
	sta (OLDTXT),y
#endif

relink_down_loop:	
	// Now advance pointer to the next line,
	lda __memmove_src+0
	sta OLDTXT+0
	lda __memmove_src+1
	sta OLDTXT+1

	// Have we run out of lines to patch?
	jsr peek_line_pointer_null_check
	bcs relink_down_next_line

	clc
	rts
	

#endif // ROM layout
