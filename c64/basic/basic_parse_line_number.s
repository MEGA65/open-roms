	
basic_parse_line_number:	
	
	jsr injest_number

	// Check if the number is a valid line number
	// i.e., 16 bits, no exponent, no decimal
	lda basic_fac1_mantissa+2
	ora basic_fac1_mantissa+3
	ora basic_fac1_exponent
	beq !+
ml_bad_line_number:
	// Invalid line number
	jmp do_ILLEGAL_QUANTITY_error
!:
	// Line number are not allowed to have decimal points in them
	lda tokenise_work4
	cmp #$FF
	bne ml_bad_line_number

	// Got a valid line number.
	lda basic_fac1_mantissa+0
	sta basic_line_number+0
	lda basic_fac1_mantissa+1
	sta basic_line_number+1
	clc
	rts
