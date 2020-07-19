// #LAYOUT# STD *       #TAKE-HIGH
// #LAYOUT# *   BASIC_0 #TAKE-HIGH
// #LAYOUT# *   *       #IGNORE

// This has to go $E000 or above - routine below banks out the main BASIC ROM!

// Find the BASIC line with number in LINNUM


#if CONFIG_MEMORY_MODEL_46K || CONFIG_MEMORY_MODEL_50K

find_line_from_start:

	// Get pointer to start of BASIC text
	jsr init_oldtxt

	// FALLTROUGH

find_line_from_current:

	// Unmap BASIC lower ROM

	lda #$26
	sta CPU_R6510

	// Check if line is not empty

	jsr peek_line_pointer_null_check
	bcc find_line_fail

	// Fetch the high byte of line number and compare

	ldy #$03
	lda (OLDTXT),y

	cmp LINNUM+1
	beq !+
	bcs find_line_fail                           // branch if line number too high
	bne find_line_next
!:

	// Fetch the low byte of line number and compare

	dey
	lda (OLDTXT),y

	cmp LINNUM+0
	beq find_line_success
	bcs find_line_fail                           // branch if line number too high
	bne find_line_next

find_line_success:

	// Restore default memory mapping and quit

	lda #$27
	sta CPU_R6510

	clc
	rts

find_line_next:

	// Advance to the next line

	jsr peek_line_pointer_null_check
	bcc find_line_fail                           // branch in no more lines exist

	ldy #$00
	lda (OLDTXT),y

	pha
	iny
	lda (OLDTXT),y

	sta OLDTXT+1
	pla
	sta OLDTXT+0

	jmp_8 find_line_from_current

find_line_fail:

	// Restore default memory mapping and quit

	lda #$27
	sta CPU_R6510


	sec
	rts

#endif
