// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE

//
// Fetches a single character, but skips spaces
//

fetch_character_skip_spaces:

	jsr fetch_character
	cmp #$20
	beq fetch_character_skip_spaces

	rts
