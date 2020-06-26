// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE

//
// A fast pseudorandom generator, modified idea from:
// - https://codebase64.org/doku.php?id=base:32bit_galois_lfsr
//
// Output:
// - FAC1
//
// See also:
// - https://www.atarimagazines.com/compute/issue72/random_numbers.php
//

rnd_generate:

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

	sec                                // make sure Carry is always set, for adc

	// FALLTROUGH

rnd_generate_copy:

	// Copy the generated number to FAC1, mangle it a little

	lda RNDX+3
	adc #$C6
	sta FAC1_mantissa+0

	lda RNDX+1
	eor #$4E
	sta FAC1_mantissa+1

	lda RNDX+4
	eor #$62
	sta FAC1_mantissa+2

	lda RNDX+2
	bit RNDX+2
	rol
	sta FAC1_mantissa+3

	// FALLTROUGH

rnd_generate_finalize:

	lda #$00
	sta FAC1_sign
	
	lda #$80
	sta FACOV                          // just to prevent 0 after normalization
	sta FAC1_exponent
	
	jmp normal_FAC1
