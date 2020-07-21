// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE

//
// Fetches address for BLOAD/BVERIFY/BSAVE, reports error if not found
//


helper_bload_fetch_address:

	jsr injest_comma
	bcs_16 do_SYNTAX_error

	lda #IDX__EV2_0B // 'SYNTAX ERROR'
	jsr fetch_uint16
	bcs_16 do_SYNTAX_error

	ldx LINNUM+0
	ldy LINNUM+1

	rts
