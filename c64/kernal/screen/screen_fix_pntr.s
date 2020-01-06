
//
// Sets PNTR in a proper range (0-39 or 40-79) depending on the
//


screen_fix_PNTR:

	ldy TBLX
	lda LDTBL, y
	php
	jsr screen_get_clipped_PNTR
	plp
	bmi screen_fix_PNTR_0_39

	// FALLTROUGH

screen_fix_PNTR_40_79:

	tya
	clc
	adc #40
	tay

	// FALLTROUGH

screen_fix_PNTR_0_39:

	sty PNTR
	rts
