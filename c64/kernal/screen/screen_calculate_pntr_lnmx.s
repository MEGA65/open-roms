// #LAYOUT# STD *        #TAKE
// #LAYOUT# X16 *        #IGNORE
// #LAYOUT# *   KERNAL_0 #TAKE
// #LAYOUT# *   *        #IGNORE

//
// Sets PNTR in a proper range (0-39 or 40-79)
// Sets LNMX to 39 or 79
//


screen_calculate_PNTR_LNMX:

	ldy TBLX
	lda LDTBL, y
	php
	jsr screen_get_clipped_PNTR
	plp
	bmi screen_calculate_PNTR_0_39

	// FALLTROUGH

screen_calculate_PNTR_40_79:

	tya
	clc
	adc #40
	tay

	// FALLTROUGH

screen_calculate_PNTR_0_39:

	sty PNTR

	// FALLTROUGH

screen_calculate_LNMX:

	ldy TBLX
	lda LDTBL, y
	bpl screen_calculate_lnmx_79       // this line is a continuation

	cpy #24
	beq screen_calculate_lnmx_39       // this is the last line, which is not a continuation

	iny
	lda LDTBL, y
	bpl screen_calculate_lnmx_79       // line is continued

	// FALLTROUGH

screen_calculate_lnmx_39:

	lda #39
	skip_2_bytes_trash_nvz

	// FALLTROUGH

screen_calculate_lnmx_79:

	lda #79
	sta LNMX
	rts
