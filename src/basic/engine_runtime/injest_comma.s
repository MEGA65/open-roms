// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE

//
// Consummes a comma in a BASIC code, Carry set if not found. Injests all spaces.
//


injest_comma:

	jsr fetch_character_skip_spaces
	cmp #$2C                           // comma character
	beq injest_comma_found
	
	// Not found

#if !HAS_OPCODES_65CE02
	jsr unconsume_character
#else
	dew TXTPTR
#endif

	sec
	rts

injest_comma_found:

	clc
	rts
