// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE

//
// A fast random generator, idea from:
// - https://codebase64.org/doku.php?id=base:32bit_galois_lfsr
//
// Output:
// - FAC1
//
// See also:
// - https://www.atarimagazines.com/compute/issue72/random_numbers.php
//

rnd_generate:

	// Generate new 4-byte random number

	asl RNDX+1
	rol RNDX+2
	rol RNDX+3
	rol RNDX+4

	bcs rnd_generate_copy

	lda RNDX+1
	eor #$B7
	sta RNDX+1
	lda RNDX+2
	eor #$1D
	sta RNDX+2
	lda RNDX+3
	eor #$C1
	sta RNDX+3
	lda RNDX+4
	eor #$04
	sta RNDX+4

	// FALLTROUGH

rnd_generate_copy:

	// Copy the number to FAC1, order changed on purpose

	lda RNDX+3
	sta FAC1_mantissa+0
	lda RNDX+1
	sta FAC1_mantissa+1
	lda RNDX+2
	sta FAC1_mantissa+2
	lda RNDX+4
	sta FAC1_mantissa+3
	
	lda #$00
	sta FACOV
	sta FAC1_sign
	
	lda #$80
	sta FAC1_exponent
	sta RNDX+0                         // in case someone tries to use the float directly
	
	jmp normal_FAC1
