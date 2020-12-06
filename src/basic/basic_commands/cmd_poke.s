;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE


cmd_poke:

	; Fetch address, store it on the stack

	jsr fetch_uint16
	+bcs do_SYNTAX_error

	lda LINNUM+0
	pha
	lda LINNUM+1
	pha

	; Fetch value

	jsr fetch_coma_uint8
	+bcs do_SYNTAX_error

	; Retrieve address

	tay
	pla
	sta LINNUM+1
	pla
	sta LINNUM+0

	; Write to memory

	tya
	ldy #$00
	sta (LINNUM), y

	rts
