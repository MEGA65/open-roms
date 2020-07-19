// #LAYOUT# STD *       #TAKE-HIGH
// #LAYOUT# *   BASIC_0 #TAKE-HIGH
// #LAYOUT# *   *       #IGNORE

// This has to go $E000 or above - routine below banks out the main BASIC ROM!

// Return C=1 if a pointer in BASIC memory space is NULL, else C=0
// X = ZP pointer to check


#if CONFIG_MEMORY_MODEL_46K || CONFIG_MEMORY_MODEL_50K

peek_line_pointer_null_check:

	// Unmap BASIC lower ROM

	lda #$26
	sta CPU_R6510

	// Check the pointer

	ldy #$01                 // for non-NULL pointer, high byte is almost certainly not NULL
	lda (OLDTXT),y
	bne !+
	
	dey
	lda (OLDTXT),y
	bne !+

	// Pointer is NULL

	lda #$27
	sta CPU_R6510

	clc
	rts
!:
	// Pointer not NULL

	lda #$27
	sta CPU_R6510

	sec
	rts

#endif
