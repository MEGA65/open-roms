// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE


//
// Tries to fetch secondary address - sets Carry if failure
//


helper_load_fetch_secondary:

	// Fetch the device number

	jsr fetch_coma_uint8
	bcs !+

	sta SA
!:
	rts
