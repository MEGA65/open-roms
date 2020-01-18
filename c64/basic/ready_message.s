// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE


ready_message:
	// See src/make_error_tables.c for packed message handling
	// information.
	ldx #29
	jmp print_packed_message
