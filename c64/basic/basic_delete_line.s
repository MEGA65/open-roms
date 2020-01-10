#if ROM_LAYOUT_STD || (ROM_LAYOUT_M65 && SEGMENT_BASIC_0)

// Delete the current BASIC line, which is assumed to have already
// been found with basic_find_line.
// Really only consists of copying memory down.
// The only complication is that we have to do the copy with ROMs
// banked out. Oh, yes, and we have to update all the links in
// the following basic lines.

basic_delete_line:

	// jsr printf
	// .text "DELETING LINE AT $"
	// .byte $f1,<OLDTXT,>OLDTXT
	// .byte $f0,<OLDTXT,>OLDTXT
	// .byte $0d,0

	// Get address of next line
	ldy #0

#if CONFIG_MEMORY_MODEL_60K
	ldx #<OLDTXT
	jsr peek_under_roms
#else // CONFIG_MEMORY_MODEL_38K
	lda (OLDTXT),y
#endif

	sta __tokenise_work3
	iny

#if CONFIG_MEMORY_MODEL_60K	
	jsr peek_under_roms
#else // CONFIG_MEMORY_MODEL_38K
	lda (OLDTXT),y
#endif

	sta __tokenise_work4

	// Work out length of this line by looking at the pointer
	lda __tokenise_work3
	sec
	sbc OLDTXT+0
	sta __tokenise_work3
	lda __tokenise_work4
	sbc OLDTXT+1
	sta __tokenise_work4

	// jsr printf
	// .text "LINE LENGTH IS $"
	// .byte $f0,<__tokenise_work4,>__tokenise_work4
	// .byte $f0,<__tokenise_work3,>__tokenise_work3
	// .byte $0d,0
	
	lda __tokenise_work4
	sbc #0
	cmp #$00
	beq !+
	// Line length is <0 or >255 bytes.
	// Either way, things are bad, so abort.
	jmp do_MEMORY_CORRUPT_error
!:
	// Length can now be safely assumed to be in the low
	// byte only, i.e., stored in __tokenise_work3

	lda __tokenise_work3
	pha
	tax

	// Shuffle everything down
	jsr basic_shift_mem_down_and_relink

	// Now decrease top of BASIC mem
	pla
	sta __tokenise_work3
	lda VARTAB+0
	sec
	sbc __tokenise_work3
	sta VARTAB+0
	lda VARTAB+1
	sbc #0
	sta VARTAB+1

	clc
	rts


#endif // ROM layout
