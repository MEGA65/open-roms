;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

;
; Fetches file name, Carry set if not found
;


helper_load_fetch_filename:

	; Check if end of statement

	jsr is_end_of_statement
	bcs @1

	; Call the expression parser, make sure it returned a string

	jsr FRMEVL

	lda VALTYP
	+bpl do_SYNTAX_error

	; Set the filename address and pointer

	lda __FAC1+0
	sta FNLEN

	lda __FAC1+1
	sta FNADDR+0
	lda __FAC1+2
	sta FNADDR+1

	; Mark success

	clc

	; FALLTROUGH

@1:
	rts
