// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE


cmd_new:

	jsr do_new

	// NEW command terminates execution (confirmed on a C64)

	jmp shell_main_loop
