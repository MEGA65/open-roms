// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE


cmd_dispose:

	jsr varstr_garbage_collect

	// Execute next statement

	jmp end_of_statement

