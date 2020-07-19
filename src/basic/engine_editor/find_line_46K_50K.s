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

	jsr find_line_null_ptr_check       // we can't use 'peek_line_pointer_null_check', it maps out/in the BASIC ROM
	beq_16 remap_BASIC_sec_rts         // search failed if there is no program

	// Fetch the high byte of line number and compare

	ldy #$03
	lda (OLDTXT),y

	cmp LINNUM+1
	beq !+
	bcs_16 remap_BASIC_sec_rts         // search failed if line number too high
	bne find_line_next
!:
	// Fetch the low byte of line number and compare

	dey
	lda (OLDTXT),y

	cmp LINNUM+0
	beq_16 remap_BASIC_clc_rts
	bcs_16 remap_BASIC_sec_rts        // search failed if line number too high
	bne find_line_next

find_line_next:

	// Advance to the next line

	jsr find_line_null_ptr_check       // we can't use 'peek_line_pointer_null_check', it maps out/in the BASIC ROM
	beq_16 remap_BASIC_sec_rts         // search failed if no more line exists

	ldy #$00
	lda (OLDTXT),y

	pha
	iny
	lda (OLDTXT),y

	sta OLDTXT+1
	pla
	sta OLDTXT+0

	jmp_8 find_line_from_current

find_line_null_ptr_check:

	// Check the pointer

	ldy #$01                           // for non-NULL pointer, high byte is almost certainly not NULL
	lda (OLDTXT),y
	bne !+
	
	dey
	lda (OLDTXT),y
	bne !+
!:
	rts


#endif
