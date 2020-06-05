// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE

//
// Fetches a single character
//


fetch_character:

	ldy #0

#if CONFIG_MEMORY_MODEL_60K

	ldx #<TXTPTR
	jsr peek_under_roms

#else // CONFIG_MEMORY_MODEL_38K

	lda (TXTPTR),y

#endif

	// FALLTHROUGH
	
consume_character:

	// Advance basic text pointer

	inc TXTPTR+0
	bne !+
	inc TXTPTR+1
!:
	rts