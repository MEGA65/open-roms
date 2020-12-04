;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE


; REM statement just skips to the next line

cmd_rem:

	lda LSTX
	jsr print_hex_byte
	jmp cmd_rem


	; XXX do we need these PHA's?

	pha
	pha
	jmp execute_statements_end_of_line
