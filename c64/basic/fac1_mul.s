// Multiply Floating Point Accumulator by 10
// = 8x + 2x
// Implement by shifting MAC left one bit,
// and then keeping that value to add on after
// shifting two more bits left.
// This should be done using BITS to
// hold the overflow bits, so that the result can
// be exponent adjusted after, if required.

fac1_mul10:
	lda #$00
	sta BITS

	// Multiply mantissa by 2
	jsr fac1_mantissa_mul2

	// copy down to BASIC numeric work area at $57
	// (TEMPF1)
	// (We copy all 7 bytes off the FAC1, so that we have
	// the overflow bits, and the copy is as small as possible)
	ldx #7
f1m10_l1:	
	lda FAC1_mantissa,x
	sta TEMPF1,x
	dex
	bpl f1m10_l1

	// Multiply mantissa by 4, so it is now 8x original
	jsr fac1_mantissa_mul2
	jsr fac1_mantissa_mul2

	// Now add stored value of 2x to it, to get the total x10
	ldy #3
	ldx #0
	clc
f1m10_l2:
	lda FAC1_mantissa,x
	adc TEMPF1,x
	sta FAC1_mantissa,x
	inx
	dey
	bpl f1m10_l2
	lda BITS
	adc TEMPF1+7
	sta BITS

	// Now shift right and increase exponent until overflow
	// bits = $00
f1m10_l3:
	lda BITS
	bne !+
	// All done, return
	clc
	rts
!:
	// Divide mantissa by two, and increment exponent
	jsr fac1_mantissa_div2
	inc FAC1_exponent
	lda FAC1_exponent
	bpl f1m10_l3
	// Exponent has bit 7 set, so has wrapped.
	// = OVERFLOW ERROR
	jmp do_OVERFLOW_error

fac1_mantissa_mul2:	
	ldy #3
	ldx #0
	clc
f1m1_l1:
	// Multiply mantissa by 2, and store overflow
	// in FAC1_bits
	lda FAC1_mantissa,x
	rol
	sta FAC1_mantissa,x
	inx
	dey
	bpl f1m1_l1
	lda BITS
	rol
	sta BITS

	rts

fac1_mantissa_div2:
	// Divide mantissa by 2, including using overflow bits
	clc
	lda BITS
	ror
	sta BITS
	ldy #3
f1md2_l1:
	lda FAC1_mantissa,y
	ror
	sta FAC1_mantissa,y
	dey
	bpl f1md2_l1
	rts
