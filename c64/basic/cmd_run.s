cmd_run:
	// RUN clears all variables
	jsr basic_do_clr
cmd_goto:
	// Reset line pointer to first line of program.
	lda TXTTAB+0
	sta OLDTXT+0
	lda TXTTAB+1
	sta OLDTXT+1

	jsr basic_end_of_statement_check
	bcs !+

	jsr basic_parse_line_number
	jsr basic_find_line
	bcc !+
	// Line doesn't exist, so report error
	jmp do_UNDEFD_STATEMENT_error
!:
	// Run it!
	jmp basic_execute_from_current_line
