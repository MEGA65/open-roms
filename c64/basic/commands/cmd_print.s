// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE



cmd_print:

	// First check if we have anything to print

	jsr end_of_statement_check
	bcs cmd_print_new_line_done

	jsr fetch_character
	cmp #$3B                           // semicolon
	beq cmd_print_done

	// FALLTROUGH

cmd_print_loop:

	jsr unconsume_character

	// FALLTROUGH

cmd_print_after_comma:

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

#if CONFIG_MEMORY_MODEL_60K

	ldx #<(__FAC1 + 1)
	jsr peek_under_roms

#else // CONFIG_MEMORY_MODEL_38K

	lda (__FAC1 + 1), y

#endif

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
	bcs cmd_print_new_line_done

	cmp #$2C                           // comma    XXX on C64 behavior is more complicated, fix it
	beq cmd_print_after_comma
	cmp #$3B                           // semicolon
	beq cmd_print_done
	bne cmd_print_loop

cmd_print_new_line_done:

	jsr print_return

	// FALLTROUGH

cmd_print_done:

	jmp basic_execute_statement
