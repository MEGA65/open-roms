// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE


cmd_restore:

	jsr do_restore

	// RESTORE command does not stop execution (confirmed on a C64)

	jmp end_of_statement
