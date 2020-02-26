// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE


cmd_clr:

	jsr basic_do_clr

	// CLR command does not stop execution
	// (Cconfirmed on a c64)
	jmp basic_execute_statement
