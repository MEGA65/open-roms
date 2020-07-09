// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE

//
// Executes the next command - after previous got finished
//


end_of_statement:
	jsr fetch_character

	cmp #$3A                           // check for colon
	beq end_of_statement_next

	cmp #$00                           // check for end of the line
	beq_16 execute_statements_end_of_line

	cmp #$20                           // check for space
	beq end_of_statement

	// Unexpectyed character

	jmp do_SYNTAX_error

end_of_statement_next:

	// Go to next statement

	// XXX this should be speed-optimized, so that no unconsume is necessary
	jsr unconsume_character
	jmp execute_statements
