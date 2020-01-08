
//
// Sets LNMX to 39 or 79
//


// YYY value is improper shortly after linee growth!


screen_calculate_LNMX: // YYY review all the code, mayybe some optimizations are possible using this value

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
