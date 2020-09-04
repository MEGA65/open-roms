// #LAYOUT# M65 BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE

#if CONFIG_MEMORY_MODEL_38K

helper_if_mega65:

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
	bne_16 helper_if_mega65_fail
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

	clc
	rts

helper_if_mega65_fail:

	sec
	rts

str_mega65:

	.byte $4D, $45, $47, $41, $36, $35

#endif
