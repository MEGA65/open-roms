// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE

//
// Fetches 8-bit unsigned integer
//


fetch_coma_uint8:

	jsr injest_comma
	bcs !+

	// FALLTROUGH

fetch_uint8:

	lda #IDX__EV2_0E                             // 'ILLEGAL QUANTITY ERROR'
	jsr fetch_uint16
	bcs !+
	lda LINNUM+1
	bne_16 do_ILLEGAL_QUANTITY_error
	lda LINNUM+0
	clc
!:	
	rts
