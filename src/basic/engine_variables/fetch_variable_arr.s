// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE


fetch_variable_arr:

	jsr find_array
	bcc !+

	// Array does not exist - we will have to create one with default parameters

	lda #$00
	sta VARPNT+1
!:
	// Fetch the 'coordinates'

	// XXX implement this

	// XXX finish the implementation

	jmp do_NOT_IMPLEMENTED_error
