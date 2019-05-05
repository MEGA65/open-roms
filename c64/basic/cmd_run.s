cmd_run:
	;; RUN clears all variables
	jsr basic_do_clr
cmd_goto:	
	;; Reset line pointer to first line of program.
	lda basic_start_of_text_ptr+0
	sta basic_current_line_ptr+0
	lda basic_start_of_text_ptr+1
	sta basic_current_line_ptr+1
	
	jsr basic_end_of_statement_check
	bcs +

	jsr basic_parse_line_number
	jsr basic_find_line
	bcc +
	;; Line doesn't exist, so report error
	jmp do_UNDEFD_STATEMENT_error
*
	;; Run it!
	jmp basic_execute_from_current_line
