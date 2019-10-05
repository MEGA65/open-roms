	
basic_parse_line_number:	
	
	jsr injest_number

	// Check if the number is a valid line number
	// i.e., 16 bits, no exponent, no decimal
	lda FAC1_mantissa+2
	ora FAC1_mantissa+3
	ora FAC1_exponent
	beq !+
ml_bad_line_number:
	// Invalid line number
	jmp do_ILLEGAL_QUANTITY_error
!:
	// Line number are not allowed to have decimal points in them
	lda __tokenise_work4
	cmp #$FF
	bne ml_bad_line_number

	// Got a valid line number.
	lda FAC1_mantissa+0
	sta LINNUM+0
	lda FAC1_mantissa+1
	sta LINNUM+1
	clc
	rts
