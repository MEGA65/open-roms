// #LAYOUT# STD *       #TAKE-HIGH
// #LAYOUT# *   BASIC_0 #TAKE-HIGH
// #LAYOUT# *   *       #IGNORE

// This has to go $E000 or above - routines below banks out the main BASIC ROM!

//
// Helper routine to copy string descriptor, for expression evaluator
//


#if CONFIG_MEMORY_MODEL_46K || CONFIG_MEMORY_MODEL_50K

helper_frmevl_strdesccpy:

	// Unmap BASIC lower ROM

	lda #$26
	sta CPU_R6510

	// Copy string descriptor

	ldy #$00
	lda (VARPNT),y
	sta __FAC1+0
	iny
	lda (VARPNT),y
	sta __FAC1+1
	iny
	lda (VARPNT),y
	sta __FAC1+2

	// FALLTROUGH

remap_BASIC:

	// Restore default memory mapping

	lda #$27
	sta CPU_R6510

	rts

#endif
