cmd_run:
	;; XXX - Parse starting line number

	;; Reset line pointer to first line of program.
	lda basic_start_of_text_ptr+0
	sta basic_current_line_ptr+0
	lda basic_start_of_text_ptr+1
	sta basic_current_line_ptr+1

	;; Run it!
	jmp basic_execute_from_current_line
