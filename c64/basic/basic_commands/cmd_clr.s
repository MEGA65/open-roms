// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE


cmd_clr:

	jsr basic_do_clr

	// CLR command does not stop execution (confirmed on a C64)

	jmp execute_statements
