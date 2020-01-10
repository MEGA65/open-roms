#if ROM_LAYOUT_STD || (ROM_LAYOUT_M65 && SEGMENT_BASIC_0)

// Insert the tokenised line stored at $0200.
// First work out where in the list to put it
// (basic_find_line with the line number can be used to work
// out the insertion point, as it should abort once it finds a
// line number too high).
// Then all we have to do is push the rest of the BASIC text up,
// and update the pointers in all following basic lines.

basic_insert_line:

	// ASSUMES basic_find_line has been called to set the insert point.
	// We need to insert space for the link link token, the line number,
	// and the zero-terminated line itself.  This means 2+2+1 plus length
	// of tokenised string after the line number

	// But first, remember where the pointer will be, so that we can
	// put the line in there after.

	// jsr printf
	// .text "INSERTING LINE AT $"
	// .byte $f1,<OLDTXT,>OLDTXT
	// .byte $f0,<OLDTXT,>OLDTXT
	// .byte $0d,0
	
	lda OLDTXT+0
	pha
	lda OLDTXT+1

	pha
	
	// Get number of bytes in tokenised line after line number
	lda __tokenise_work2
	sec
	sbc __tokenise_work1
	// Add on the four bytes space we need
	clc
	adc #5
	pha
	tax
	
	// Make the space
	jsr basic_shift_mem_up_and_relink

	// Now increase top of BASIC mem
	pla
	clc
	adc VARTAB+0
	sta VARTAB+0
	lda VARTAB+1
	adc #0
	sta VARTAB+1
	
	// Get pointer back
	pla
	sta OLDTXT+1
	pla
	sta OLDTXT+0

	// Write the line number
	ldy #2
	lda LINNUM+0

#if CONFIG_MEMORY_MODEL_60K
	ldx #<OLDTXT+0
	jsr poke_under_roms
#else // CONFIG_MEMORY_MODEL_38K
	sta (OLDTXT),y
#endif

	iny
	lda LINNUM+1

#if CONFIG_MEMORY_MODEL_60K
	jsr poke_under_roms
#else // CONFIG_MEMORY_MODEL_38K
	sta (OLDTXT),y
#endif

	// Now store the line body itself
	inc __tokenise_work2
line_store_loop:
	ldx __tokenise_work1
	lda $0200,x
	inc __tokenise_work1
	iny

#if CONFIG_MEMORY_MODEL_60K
	ldx #<OLDTXT+0
	jsr poke_under_roms
#else // CONFIG_MEMORY_MODEL_38K
	sta (OLDTXT),y
#endif

	lda __tokenise_work1
	cmp __tokenise_work2
	bne line_store_loop
	dec __tokenise_work2
	
	clc
	rts


#endif // ROM layout
