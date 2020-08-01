// #LAYOUT# STD *       #TAKE-HIGH
// #LAYOUT# *   BASIC_0 #TAKE-HIGH
// #LAYOUT# *   *       #IGNORE

// This has to go $E000 or above - routine below banks out the main BASIC ROM!

#if CONFIG_MEMORY_MODEL_46K || CONFIG_MEMORY_MODEL_50K

helper_array_check_no_dims:

	// Unmap BASIC lower ROM

	lda #$26
	sta CPU_R6510

	// Check number of dimensions

	ldy #$04
	txa
	cmp (VARPNT), y

	// Restore default memory mapping

	jmp remap_BASIC_preserve_P

#endif
