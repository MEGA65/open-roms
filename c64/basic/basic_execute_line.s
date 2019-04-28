	;; Go through the line until its end is reached.
	;; If we reach the end are in direct mode, then
	;; go back to reading input, else look for the
	;; next line, and advance to that, or else
	;; return to READY prompt because we have run out
	;; of program.

basic_execute_line:	

	;; Get next char of program text, even if it is hiding under a ROM or the
	;; IO area.
	ldx #<basic_current_statement_ptr
	ldy #0
	jsr peek_under_roms
	
	;; The checks should be done in order of frequency, so that we are as
	;; fast as possible.

	;; Space, which we can also just ignore
	cmp #$20
	beq basic_skip_char
	;; End of line?
	cmp #$00
	beq basic_end_of_line
	;; :, i.e., statement separator, which we can simply ignore
	cmp #$3a
	beq basic_skip_char
	
	;; If all else fails, it's a syntax error
	ldx #10
	jmp do_basic_error

	jmp basic_main_loop

basic_skip_char:
	;; Advance basic text pointer
	inc basic_current_statement_ptr+0
	bne +
	inc basic_current_statement_ptr+1
*	jmp basic_execute_line
	
basic_end_of_line:

	;; XXX - If not in direct mode, then advance to next line, if there is
	;; one.
	
	jmp basic_main_loop
