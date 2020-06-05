// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE

//
// Fetches device number and secondary address - if they are present
//


fetch_device_secondary:

	// Fetch the device number

	jsr injest_comma
	bcs fetch_secondary

	jsr injest_spaces
	jsr basic_parse_line_number
	lda LINNUM+1
	bne_16 do_ILLEGAL_QUANTITY_error

	lda LINNUM+0
	sta FA

	// FALLTROUGH

fetch_secondary:

	// Fetch secondary address

	jsr injest_comma
	bcs fetch_device_secondary_done

	jsr injest_spaces
	jsr basic_parse_line_number
	lda LINNUM+1
	bne_16 do_ILLEGAL_QUANTITY_error

	lda LINNUM+0
	sta SA

	// FALLTROUGH

fetch_device_secondary_done:

	rts
