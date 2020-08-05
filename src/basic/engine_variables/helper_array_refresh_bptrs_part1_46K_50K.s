// #LAYOUT# STD *       #TAKE-HIGH
// #LAYOUT# *   BASIC_0 #TAKE-HIGH
// #LAYOUT# *   *       #IGNORE

// This has to go $E000 or above - routine below banks out the main BASIC ROM!

#if CONFIG_MEMORY_MODEL_46K || CONFIG_MEMORY_MODEL_50K

helper_array_refresh_bptrs_part1:

	// Unmap BASIC lower ROM

	lda #$26
	sta CPU_R6510

	// Calculate start address of the next array, store it in INDEX+2/+3

	ldy #$02

	lda (INDEX+0), y // XXX
	clc
	adc INDEX+0
	sta INDEX+2 
	iny
	lda (INDEX+0), y // XXX
	adc INDEX+1
	sta INDEX+3

	// Check if the current array is a string - if not, go to next array

	ldy #$00
	lda (INDEX+0), y // XXX
	bmi_16 remap_BASIC_sec_rts
	iny
	lda (INDEX+0), y // XXX
	bpl_16 remap_BASIC_sec_rts

	// It's a string array - scroll INDEX+0/+1 to the first descriptor

	ldy #$04
	lda (INDEX+0), y // XXX
	asl
	clc
	adc #$05
	jsr helper_INDEX_up_A
!:
	// Restore default memory mapping

	jmp remap_BASIC_clc_rts

#endif
