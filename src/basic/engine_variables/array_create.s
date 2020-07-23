// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE


array_create:

	// First retrieve array name

	jsr fetch_variable_name
	bcs_16 do_SYNTAX_error

	// XXX check if the array already exists

	// It will be easier if we first perform garbage collection (arrays are not declared often)

	jsr varstr_garbage_collect

	// XXX bit DIMFLG, bmi = use default params



	// XXX

	jsr do_NOT_IMPLEMENTED_error
