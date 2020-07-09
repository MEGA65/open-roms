// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE

//
// Executes the next command - after previous got finished
//


end_of_statement:

	jsr fetch_character

	cmp #$20                           // check for space
	beq end_of_statement

	cmp #$3A                           // check for colon
	beq_16 execute_statements

	cmp #$00                           // check for end of the line
	beq_16 execute_statements_end_of_line

	// Unexpected character

	jmp do_SYNTAX_error
