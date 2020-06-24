// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE

// Return C=1 if a pointer in BASIC memory space is NULL, else C=0
// X = ZP pointer to check

peek_line_pointer_null_check:

	ldy #$00

#if CONFIG_MEMORY_MODEL_60K
	ldx #<OLDTXT+0
	jsr peek_under_roms
	cmp #$00
#elif CONFIG_MEMORY_MODEL_46K || CONFIG_MEMORY_MODEL_50K
	jsr peek_under_roms_via_OLDTXT
	cmp #$00
#else // CONFIG_MEMORY_MODEL_38K
	lda (OLDTXT),y
#endif

	bne ptr_not_null
	iny

#if CONFIG_MEMORY_MODEL_60K
	jsr peek_under_roms
	cmp #$00
#elif CONFIG_MEMORY_MODEL_46K || CONFIG_MEMORY_MODEL_50K
	jsr peek_under_roms_via_OLDTXT
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
