// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE



cmd_let:

	// Fetch variable name, should be followed by assign operator

	jsr fetch_variable
	jsr injest_assign
	bcs_16 do_SYNTAX_error

	// XXX finish the implementation

	jmp do_NOT_IMPLEMENTED_error
