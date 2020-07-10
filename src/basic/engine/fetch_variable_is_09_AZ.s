// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE

//
// Check .A content, if within 0-9, A-Z ranges, sets Carry if check fails
//

fetch_variable_is_09_AZ:

	cmp #$41                                 // fail if below '0'
	bcc fetch_variable_cmp_fail

	cmp #$3A                                 // continue checking if above '9'
	bcc fetch_variable_cmp_rts 

	// FALLTROUGH

fetch_variable_is_AZ:

	cmp #$41                                 // fail if below 'A'
	bcc fetch_variable_cmp_fail

	cmp #$7B                                 // fail if above 'Z'

	// FALLTROUGH

fetch_variable_cmp_rts:

	rts

fetch_variable_cmp_fail:

	sec
	rts
