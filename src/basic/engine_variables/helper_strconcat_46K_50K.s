// #LAYOUT# STD *       #TAKE-HIGH
// #LAYOUT# *   BASIC_0 #TAKE-HIGH
// #LAYOUT# *   *       #IGNORE

// This has to go $E000 or above - routines below banks out the main BASIC ROM!

//
// Helper routine for string concatenation
//


#if CONFIG_MEMORY_MODEL_46K || CONFIG_MEMORY_MODEL_50K

helper_strconcat:

	// Unmap BASIC lower ROM

	lda #$26
	sta CPU_R6510

	// Copy data from the first string

	ldy #$00
!:
	lda (__FAC2+1),y
	sta (INDEX),y
	iny
	cpy __FAC2+0
	bne !-

	// Increase INDEX pointer by the size of the 1st string

	tya
	jsr helper_INDEX_up_A

	// Copy data from the second string

	ldy #$00
!:
	lda (__FAC1+1),y
	sta (INDEX),y
	iny
	cpy __FAC1+0
	bne !-

	// Restore default memory mapping

	lda #$27
	sta CPU_R6510

	rts

#endif
