// #LAYOUT# STD *       #TAKE-HIGH
// #LAYOUT# *   BASIC_0 #TAKE-HIGH
// #LAYOUT# *   *       #IGNORE

// This has to go $E000 or above - routine below banks out the main BASIC ROM!

#if CONFIG_MEMORY_MODEL_46K || CONFIG_MEMORY_MODEL_50K

helper_array_fetch_dimension:

	// Unmap BASIC lower ROM

	lda #$26
	sta CPU_R6510

	// Fetch the dimension

	lda (VARPNT), y
	sta __FAC1+4
	iny
	lda (VARPNT), y
	sta __FAC1+3
	iny

	// Restore default memory mapping

	lda #$27
	sta CPU_R6510

	rts

#endif
