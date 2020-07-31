// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE

//
// Consummes assign operator in a BASIC code, triggers error if not found
//


injest_assign:

	jsr fetch_character_skip_spaces
	cmp #$B2                           // assign operator character
	bne_16 do_SYNTAX_error

	rts
