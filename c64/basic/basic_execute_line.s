	;; Go through the line until its end is reached.
	;; If we reach the end are in direct mode, then
	;; go back to reading input, else look for the
	;; next line, and advance to that, or else
	;; return to READY prompt because we have run out
	;; of program.

basic_execute_line:	


	;; If all else fails, it's a syntax error
	ldx #10
	jmp do_basic_error

	jmp basic_main_loop
