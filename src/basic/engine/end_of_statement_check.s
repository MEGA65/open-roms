// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE

//
// Check for end of statement, sets Carry if so. Injests all spaces.
//


end_of_statement_check:

	// XXX consider optimized version for 46K/56K memory models

	ldy #$00

#if CONFIG_MEMORY_MODEL_60K
	ldx #<TXTPTR
	jsr peek_under_roms
#elif CONFIG_MEMORY_MODEL_46K || CONFIG_MEMORY_MODEL_50K
	jsr peek_under_roms_via_TXTPTR
#else // CONFIG_MEMORY_MODEL_38K
	lda (TXTPTR),y
#endif

	// Injest any spaces

	cmp #$20
	bne !+
	jsr consume_character
	jmp end_of_statement_check
!:
	cmp #$00
	beq !+
	cmp #$3A
	beq !+

	// Not end of statement

	clc
	rts
!:
	// End of statement

	sec
	rts
