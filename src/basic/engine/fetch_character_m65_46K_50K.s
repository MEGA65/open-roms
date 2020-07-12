// #LAYOUT# M65 BASIC_0 #TAKE-HIGH
// #LAYOUT# *   *       #IGNORE

//
// Fetches a single character - optimized version
//


#if CONFIG_MEMORY_MODEL_46K || CONFIG_MEMORY_MODEL_50K


fetch_character:

	ldy #0

	// Unmap BASIC lower ROM

	lda #$26
	sta CPU_R6510

	// Retrieve value from under ROMs

	lda (TXTPTR), y

	// Restore memory mapping

	pha
	lda #$27
	sta CPU_R6510
	pla

	// FALLTROUGH
	
consume_character:

	// Advance basic text pointer

	inw TXTPTR
	rts


#endif
