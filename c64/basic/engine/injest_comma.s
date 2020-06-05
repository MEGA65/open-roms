// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE

//
// Consummes a comma in a BASIC code, Carry set if not found. Injests all spaces.
//


injest_comma:

	jsr fetch_character
	cmp #$2C                           // comma character
	beq injest_comma_found
	cmp #$20                           // space, can always be skipped
	beq injest_comma
	
	// Not found
	jsr unconsume_character

	sec
	rts

injest_comma_found:

	clc
	rts
