// Delete the current BASIC line, which is assumed to have already
// been found with basic_find_line.
// Really only consists of copying memory down.
// The only complication is that we have to do the copy with ROMs
// banked out. Oh, yes, and we have to update all the links in
// the following basic lines.

basic_delete_line:

	// jsr printf
	// .text "DELETING LINE AT $"
	// .byte $f1,<basic_current_line_ptr,>basic_current_line_ptr
	// .byte $f0,<basic_current_line_ptr,>basic_current_line_ptr
	// .byte $0d,0

	// Get address of next line
	ldy #0

#if CONFIG_MEMORY_MODEL_60K
	ldx #<basic_current_line_ptr
	jsr peek_under_roms
#else // CONFIG_MEMORY_MODEL_38K
	lda (basic_current_line_ptr),y
#endif

	sta tokenise_work3
	iny

#if CONFIG_MEMORY_MODEL_60K	
	jsr peek_under_roms
#else // CONFIG_MEMORY_MODEL_38K
	lda (basic_current_line_ptr),y
#endif

	sta tokenise_work4

	// Work out length of this line by looking at the pointer
	lda tokenise_work3
	sec
	sbc basic_current_line_ptr+0
	sta tokenise_work3
	lda tokenise_work4
	sbc basic_current_line_ptr+1
	sta tokenise_work4

	// jsr printf
	// .text "LINE LENGTH IS $"
	// .byte $f0,<tokenise_work4,>tokenise_work4
	// .byte $f0,<tokenise_work3,>tokenise_work3
	// .byte $0d,0
	
	lda tokenise_work4
	sbc #0
	cmp #$00
	beq !+
	// Line length is <0 or >255 bytes.
	// Either way, things are bad, so abort.
	jmp do_MEMORY_CORRUPT_error
!:
	// Length can now be safely assumed to be in the low
	// byte only, i.e., stored in tokenise_work3

	lda tokenise_work3
	pha
	tax

	// Shuffle everything down
	jsr basic_shift_mem_down_and_relink

	// Now decrease top of BASIC mem
	pla
	sta tokenise_work3
	lda basic_end_of_text_ptr+0
	sec
	sbc tokenise_work3
	sta basic_end_of_text_ptr+0
	lda basic_end_of_text_ptr+1
	sbc #0
	sta basic_end_of_text_ptr+1

	clc
	rts
