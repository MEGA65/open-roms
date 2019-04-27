	;; Parse a number from the input buffer at $0200+tokenise_work1
	;; Result is put into FAC1.
	;; tokenise_work1 is updated with first position after the number.

	;; XXX - Remember decimal position and exponent, and apply them
	;; after to produce normalised floating point number.

ij_not_a_digit:
	;; XXX check for ".", "E", "+" and "-"
	;; Other chars terminate the accumulation.
	CLC
	RTS
	
inject_number:
	;; Clear FAC1
	jsr erase_fac1

	;; Clear decimal position flag
	lda #$ff
	sta tokenise_work2

	;; Check if leading char is a - sign
	;; Note: the - will have been tokenised to $AB
	;; XXX - implement
	
ij_loop1:	
	ldx tokenise_work1
	lda $0200,x
	cmp #$30
	bcc ij_not_a_digit
	cmp #$39
	bcs ij_not_a_digit

	;; It is a digit

	;; Only add digit if we have not overflowed the accuracy of
	;; the mantissa
	lda basic_fac1_exponent
	beq ij_accept_precision

	;; We have an extra digit after saturating our precision.
	;; Thus we should ignore the digit, and just multiply the FAC
	;; by 10, but only if we have not seen a decimal point.
	;; If we have seen a decimal point, then we can completely ignore
	;; the digit, as it is contributing not recordable information

	lda tokenise_work2
	cmp #$ff
	bne ij_seen_decimal_point
	
	jsr fac1_mul10
	;; Fall through
ij_seen_decimal_point:
	jmp ij_consider_next_digit
	
ij_accept_precision:
	;; We can accept more precision, so multiply the mantissa by 10, so that
	;; we can add the new digit in
	jsr fac1_mul10

	lda basic_fac1_exponent
	bne ij_consider_next_digit
	
	;; Get digit
	ldx tokenise_work1
	lda $0200,x
	sec
	sbc #$30

	;; Add to FAC1 mantissa
	clc
	adc basic_fac1_mantissa+0
	sta basic_fac1_mantissa+0
	ldx #1
	ldy #3
ij_loop2:	
	lda basic_fac1_mantissa,x
	adc #$00
	sta basic_fac1_mantissa+1,x
	inx
	dey
	bne ij_loop2

	bcc +
	;; Carry set, so we have overflowed.
	;; We should shift everything right one digit, and increase
	;; the exponent by one.  The non-zero exponent tells us that we
	;; can't fit any more precision in.
	jsr fac1_mantissa_div2
*

ij_consider_next_digit:	
	;; Consider next digit
	inc tokenise_work1
	jmp ij_loop1
	
	rts


erase_fac1:	
	lda #$00
	ldx #7
*
	sta basic_fac1_exponent,x
	dex
	bpl -
	sta basic_fac1_mantissa_lob

	rts
	
	
