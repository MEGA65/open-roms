// #LAYOUT# M65 BASIC_0 #TAKE-HIGH
// #LAYOUT# *   *       #IGNORE

// This has to go $E000 or above - routine below banks out the main BASIC ROM!

#if CONFIG_MEMORY_MODEL_46K || CONFIG_MEMORY_MODEL_50K

helper_if_mega65:

	// Unmap BASIC lower ROM

	lda #$26
	sta CPU_R6510

	// Injest all spaces

	ldy #$00
!:
	lda (TXTPTR), Y
	cmp #$20
	bne !+
	inw TXTPTR
	bra !-
!:

	// Check for MEGA65 untokenized keyword

	ldy #$05
!:
	lda (TXTPTR), Y
	cmp str_mega65, Y
	bne_16 remap_BASIC_sec_rts
	dey
	bpl !-

	// Increment TXTPTR by 6

	clc
	lda TXTPTR+0
	adc #$06
	sta TXTPTR+0
	bcc !+
	inc TXTPTR+1
!:
	// Report successful check

	jmp remap_BASIC_clc_rts

str_mega65:

	.byte $4D, $45, $47, $41, $36, $35


#endif
