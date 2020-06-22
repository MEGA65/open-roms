// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE

//
// Fetches device number and secondary address - if they are present
//


fetch_device_secondary:

	// Fetch the device number

	jsr fetch_device_secondary_uint8
	bcs fetch_device_secondary_done

	sta FA

	// FALLTROUGH

fetch_secondary:

	// Fetch secondary address

	jsr fetch_device_secondary_uint8
	bcs fetch_device_secondary_done

	sta SA

	// FALLTROUGH

fetch_device_secondary_done:

	rts


fetch_device_secondary_uint8: // also called by 'cmd_merge'

	jsr injest_comma
	bcs !+

	jsr injest_spaces
	jsr basic_parse_line_number
	lda LINNUM+1
	bne_16 do_ILLEGAL_QUANTITY_error
	lda LINNUM+0
	clc
!:	
	rts
