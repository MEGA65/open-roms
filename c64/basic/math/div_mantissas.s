// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE

// Math package - 32-bit mantissa division, based on code by Verz
//
// divident: FAC2_mantissa, divisor: FAC1_mantissa (without FACOV), result: FAC2_mantissa, remainder: RESHO
// temporary storage: INDEX+0, INDEX+1, INDEX+2, INDEX+3
//
// RESHO (remainder) should be set to 0 before
//
// see https://codebase64.org/doku.php?id=base:24bit_division_24-bit_result

// XXX test this

div_mantissas:

	ldx #32                            // repeat for each bit

	// FALLTROUGH

div_mantissas_loop:

	// Multiply divident by 2, msb -> Carry

	asl FAC2_mantissa+3
	rol FAC2_mantissa+2
	rol FAC2_mantissa+1
	rol FAC2_mantissa+0

	// Multiply remainder by 2, lsb <- Carry

	rol RESHO+3
	rol RESHO+2
	rol RESHO+1
	rol RESHO+0

	// Subtract divisor from the remainder, result to INDEX and .Y

	sec
	lda RESHO+3
	sbc FAC1_mantissa+3
	sta INDEX+3

	lda RESHO+2
	sbc FAC1_mantissa+2
	sta INDEX+2

	lda RESHO+1
	sbc FAC1_mantissa+1
	sta INDEX+1

	lda RESHO+0
	sbc FAC1_mantissa+0

	bcc div_mantissas_skip             // if Carry is not set then divisor did not fit in remainder yet
	sta INDEX+0

	// Save subtraction result as new remainder

	lda INDEX+3
	sta RESHO+3

	lda INDEX+2
	sta RESHO+2

	lda INDEX+1
	sta RESHO+1

	lda INDEX+0
	sta RESHO+0

	// Increment result cause divisor fit in 1 times

	inc FAC2_mantissa+3

	// FALLTROUGH

div_mantissas_skip:

	dex
	bne div_mantissas_loop

	rts
