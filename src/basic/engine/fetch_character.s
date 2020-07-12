// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE

//
// Fetches a single character
//


// For these configurations we have optimized version in another file
#if !(ROM_LAYOUT_M65 && (CONFIG_MEMORY_MODEL_46K || CONFIG_MEMORY_MODEL_50K))

fetch_character:

	ldy #0

#if CONFIG_MEMORY_MODEL_60K

	ldx #<TXTPTR
	jsr peek_under_roms

#elif CONFIG_MEMORY_MODEL_46K || CONFIG_MEMORY_MODEL_50K

	jsr peek_under_roms_via_TXTPTR

#else // CONFIG_MEMORY_MODEL_38K

	lda (TXTPTR),y

#endif

#if !HAS_OPCODES_65CE02

	// FALLTHROUGH
	
consume_character:

	// Advance basic text pointer

	inc TXTPTR+0
	bne !+
	inc TXTPTR+1
!:

#else // HAS_OPCODES_65CE02

	// Advance basic text pointer

	inw TXTPTR

#endif

	rts


#endif
