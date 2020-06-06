// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE



cmd_print:

	// First check if we have anything to print

	jsr end_of_statement_check
	bcs cmd_print_new_line

	jsr fetch_character
	cmp #$3B                           // semicolon
	beq cmd_print_done

	jsr unconsume_character

	// FALLTROUGH

cmd_print_loop:

	// Now evaluate the expression

	jsr FRMEVL
	lda VALTYP
	bpl cmd_print_float

	// FALLTROUGH

cmd_print_string:

	// Print a string value

	ldy #$00
!:
	cpy __FAC1 + 0
	beq cmd_print_next_arg

	lda (__FAC1 + 1), y                // XXX read from under ROM
	jsr JCHROUT
	iny
	jmp !-

cmd_print_float:

	// XXX probably we should also check INTFLG here
	// XXX provide implementation

	// FALLTROUGH

cmd_print_next_arg:

	// Look for the next argument

	jsr end_of_statement_check
	bcs cmd_print_new_line

	jsr fetch_character
	cmp #$2C                           // comma
	beq cmd_print_loop
	cmp #$3B                           // semicolon
	beq cmd_print_done

	// Something unexpected

	jmp do_SYNTAX_error

cmd_print_new_line:

	jsr print_return

	// FALLTROUGH

cmd_print_done:

	jmp basic_execute_statement
