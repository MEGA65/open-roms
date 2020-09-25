;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

;
; Fetches line number, stores it in LINNUM, sets Carry to indicate failure (not a number)
;
; Preserves both .X and .Y
;

fetch_line_number:

	lda #IDX__EV7_26 ; 'LINE NUMBER TOO LARGE'
	jsr fetch_uint16
	+bcs do_SYNTAX_error

	lda LINNUM+1
	cmp #$FF
	+beq do_LINE_NUMBER_TOO_LARGE_error

	rts
