// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE

//
// Allocates area for a temporary string
//
// Input:
// - .A - string length
//


// XXX - finish the implementation once string memory handling is done


alloc_temp_string:

	// Check if temporary descriptor stack has a free slot

	ldx LASTPT
	cpx #$1F
	bcs_16 do_FORMULA_TOO_COMPLEX_error

	// XXX

	jmp do_NOT_IMPLEMENTED_error
