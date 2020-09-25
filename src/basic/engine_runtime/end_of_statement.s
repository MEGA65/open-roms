;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

;
; Executes the next command - after previous got finished
;


end_of_statement:

	jsr tmpstr_free_all
	jsr fetch_character_skip_spaces

	cmp #$3A                           ; check for colon
	+beq execute_statements

	cmp #$00                           ; check for end of the line
	+beq execute_statements_end_of_line

	; Unexpected character

	jmp do_SYNTAX_error
