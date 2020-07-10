// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE

//
// Consummes assign operator in a BASIC code, Carry set if not found. Injests all spaces.
//


injest_assign:

	jsr fetch_character
	cmp #$B2                           // assign operator character
	beq injest_assign_found
	cmp #$20                           // space, can always be skipped
	beq injest_assign
	
	// Not found
	jsr unconsume_character

	sec
	rts

injest_assign_found:

	clc
	rts
