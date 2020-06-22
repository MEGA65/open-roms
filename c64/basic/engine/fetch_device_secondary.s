// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE

//
// Fetches device number and secondary address - if they are present
//


fetch_device_secondary:

	// Fetch the device number

	jsr fetch_coma_uint8
	bcs fetch_device_secondary_done

	sta FA

	// FALLTROUGH

fetch_secondary:

	// Fetch secondary address

	jsr fetch_coma_uint8
	bcs fetch_device_secondary_done

	sta SA

	// FALLTROUGH

fetch_device_secondary_done:

	rts
