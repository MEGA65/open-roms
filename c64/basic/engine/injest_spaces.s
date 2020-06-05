// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE

//
// Injests all spaces.
//

// XXX get rid of this when proper number parsing is completed


injest_spaces:

	jsr fetch_character
	cmp #$20                           // space, can be skipped
	beq injest_spaces
	
	jmp unconsume_character
