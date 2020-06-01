// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE


cmd_new:

	jsr basic_do_new

	// NEW command terminates execution
	// (Confirmed on a C64)
	jmp basic_main_loop
