// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE

//
// Initialize random seed using values from FAC1,
// afterwards generate random number in FAC1
//

rnd_seed_from_FAC1:

	lda FAC1_mantissa+0
	sta RNDX+4

	eor FAC1_mantissa+1
	sta RNDX+3

	eor FAC1_mantissa+2
	sta RNDX+2

	eor FAC1_mantissa+3
	sta RNDX+1

	eor FAC1_exponent
	sta RNDX+0

	jmp rnd_generate
