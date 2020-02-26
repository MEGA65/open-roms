// #LAYOUT# STD *       #TAKE
// #LAYOUT# X16 BASIC_0 #TAKE-OFFSET 2000
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE

//
// Math package - divide FAC2 (dividend) by FAC1 (divisor), ignores sign
//
// Input:
// - .A - must load FAC1 exponent ($61) beforehand to set the zero flag
//
// Output:
// - leaves the quotient FAC1 and the remainder in FAC2
//
// See also:
// - [CM64] Computes Mapping the Commodore 64 - page 114
// - https://www.c64-wiki.com/wiki/Floating_point_arithmetic
// - https://codebase64.org/doku.php?id=base:kernal_floating_point_mathematics
//

// XXX provide implementation

div_FAC2_FAC1:
	STUB_IMPLEMENTATION()






// XXX move this to a separate file

// Unsigned integer 32-bit mantissa division, based on code by Verz
// divident: FAC2_mantissa, divisor: FAC1_mantissa, result: FAC2_mantissa, remainder: RESHO
// temporary storage: INDEX+1, INDEX+2, INDEX+3
//
// https://codebase64.org/doku.php?id=base:24bit_division_24-bit_result

// XXX test this, optimize (for temporary storage use .Y, .Z and RESHO+4)

div_mantissas:

	// Preset remainder to 0
	// XXX should be common with multiplication

	lda #$00
	sta RESHO+0
	sta RESHO+1
	sta RESHO+2
	sta RESHO+3

	ldx #$32                           // repeat for each bit

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

	// Subtract divisor to see if it fits in

	lda RESHO+3
	sec
	sbc FAC1_mantissa+2
	sta INDEX+3
	
	lda RESHO+2
	sbc FAC1_mantissa+2
	sta INDEX+2

	lda RESHO+1
	sbc FAC1_mantissa+1
	sta INDEX+1

	lda RESHO+0
	sbc FAC1_mantissa+0
	bcc div_mantissas_skip             // if Carry is not set then divisor did not fit in yet

	sta RESHO+0                        // else save substraction result as new remainder,
	lda INDEX+1
	sta RESHO+1
	lda INDEX+2
	sta RESHO+2
	lda INDEX+3
	sta RESHO+3

	inc FAC2_mantissa+3                // and INCrement result cause divisor fit in 1 times

	// FALLTROUGH

div_mantissas_skip:

	dex
	bne div_mantissas_loop

	rts
