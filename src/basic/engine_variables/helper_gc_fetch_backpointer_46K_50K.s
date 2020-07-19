// #LAYOUT# STD *       #TAKE-HIGH
// #LAYOUT# *   BASIC_0 #TAKE-HIGH
// #LAYOUT# *   *       #IGNORE

// This has to go $E000 or above - routine below banks out the main BASIC ROM!

#if CONFIG_MEMORY_MODEL_46K || CONFIG_MEMORY_MODEL_50K

helper_gc_fetch_backpointer:

	// Unmap BASIC lower ROM

	lda #$26
	sta CPU_R6510

	// Copy the back-pointer to OLDTXT, check if it is NULL

	ldy #$00
	lda (TXTPTR),y
	sta OLDTXT+0

	iny
	lda (TXTPTR),y
	sta OLDTXT+1

	ora OLDTXT+0

	// Restore default memory mapping

	jmp remap_BASIC_preserve_P

#endif
