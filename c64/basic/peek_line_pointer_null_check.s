#if ROM_LAYOUT_STD || (ROM_LAYOUT_M65 && SEGMENT_BASIC_0)

// Return C=1 if a pointer in BASIC memory space is NULL, else C=0
// X = ZP pointer to check

peek_line_pointer_null_check:

	ldy #$00

#if CONFIG_MEMORY_MODEL_60K
	ldx #<OLDTXT+0
	jsr peek_under_roms
	cmp #$00
#else // CONFIG_MEMORY_MODEL_38K
	lda (OLDTXT),y
#endif

	bne ptr_not_null
	iny

#if CONFIG_MEMORY_MODEL_60K
	jsr peek_under_roms
	cmp #$00
#else // CONFIG_MEMORY_MODEL_38K
	lda (OLDTXT),y
#endif

	bne ptr_not_null

	// Pointer is NULL
	clc
	rts

ptr_not_null:
	sec
	rts


#endif // ROM layout
