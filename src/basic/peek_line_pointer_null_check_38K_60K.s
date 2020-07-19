// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE

// Return C=1 if a pointer in BASIC memory space is NULL, else C=0
// X = ZP pointer to check


#if CONFIG_MEMORY_MODEL_38K || CONFIG_MEMORY_MODEL_60K

peek_line_pointer_null_check:

	// Check the pointer

	ldy #$01                 // for non-NULL pointer, high byte is almost certainly not NULL

#if CONFIG_MEMORY_MODEL_60K
	ldx #<OLDTXT+0
	jsr peek_under_roms
	cmp #$00
#else // CONFIG_MEMORY_MODEL_38K
	lda (OLDTXT),y
#endif

	bne !+
	dey

#if CONFIG_MEMORY_MODEL_60K
	jsr peek_under_roms
	cmp #$00
#else // CONFIG_MEMORY_MODEL_38K
	lda (OLDTXT),y
#endif

	bne !+

	// Pointer is NULL

	clc
	rts
!:
	// Pointer not NULL

	sec
	rts

#endif
