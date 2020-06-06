// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE



cmd_print:

	// XXX print an argument here


	// Look for the next argument

	jsr end_of_statement_check
	bcs cmd_print_new_line

	jsr fetch_character
	cmp #$2C                           // comma
	beq cmd_print
	cmp #$3B                           // semicolon
	beq cmd_print_done

cmd_print_new_line:

	jsr print_return

	// FALLTROUGH

cmd_print_done:

	jmp basic_main_loop
