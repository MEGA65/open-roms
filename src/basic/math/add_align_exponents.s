// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE

//
// Math package - align FAC1 and FAC2 exponents for addition
//
// See also:
// - [CM64] Computes Mapping the Commodore 64 - page 115
// - https://www.c64-wiki.com/wiki/BASIC-ROM

add_align_exponents:

	// XXX assume here none of the exponents is 0, check if this is true for orignal ROMs

	lda FAC1_exponent
	cmp FAC2_exponent
	beq add_align_exponents_done       // branch if exponents the same
	bcs add_align_exponent_FAC2

	// FALLTROUGH

add_align_exponent_FAC1:

	// First check the exponent difference

	lda FAC2_exponent
	sec
	sbc FAC1_exponent

	cmp #$28
	bcs add_align_exponent_FAC1_zero   // branch if difference is very high

	cmp #$08
	bcc add_align_exponent_FAC1_bit
	
	// FALLTROUGH

add_align_exponent_FAC1_byte:

	// Add 8 to exponent, divide mantissa by 256

	lda FAC1_exponent
	clc
	adc #$08
	sta FAC1_exponent

	lda FAC1_mantissa+3
	sta FACOV
	lda FAC1_mantissa+2
	sta FAC1_mantissa+3
	lda FAC1_mantissa+1
	sta FAC1_mantissa+2
	lda FAC1_mantissa+0
	sta FAC1_mantissa+1
	lda #$00
	sta FAC1_mantissa+0

	beq add_align_exponent_FAC1        // branch always - next iteration

add_align_exponent_FAC1_bit:

	// Increment exponent, divide mantissa by 2

	inc FAC1_exponent

	clc
	ror FAC1_mantissa+0
	ror FAC1_mantissa+1
	ror FAC1_mantissa+2
	ror FAC1_mantissa+3
	ror FACOV

	lda FAC1_exponent
	cmp FAC2_exponent
	bne add_align_exponent_FAC1_bit    // branch if next iteration needed

	rts

add_align_exponent_FAC1_zero:

	lda #$00

	sta FAC1_mantissa+0
	sta FAC1_mantissa+1
	sta FAC1_mantissa+2
	sta FAC1_mantissa+3
	sta FACOV

	lda FAC2_exponent
	sta FAC1_exponent

	// FALLTROUGH

add_align_exponents_done:

	rts



add_align_exponent_FAC2:

	// First check the exponent difference, Carry already set here

	lda FAC1_exponent
	sbc FAC2_exponent

	cmp #$20
	bcs add_align_exponent_FAC2_zero   // branch if difference is very high

	cmp #$08
	bcc add_align_exponent_FAC2_bit
	
	// FALLTROUGH

add_align_exponent_FAC2_byte:

	// Add 8 to exponent, divide mantissa by 256

	lda FAC2_exponent
	clc
	adc #$08
	sta FAC2_exponent

	lda FAC2_mantissa+2
	sta FAC2_mantissa+3
	lda FAC2_mantissa+1
	sta FAC2_mantissa+2
	lda FAC2_mantissa+0
	sta FAC2_mantissa+1
	lda #$00
	sta FAC2_mantissa+0

	beq add_align_exponent_FAC2        // branch always - next iteration

add_align_exponent_FAC2_bit:

	// Increment exponent, divide mantissa by 2

	inc FAC2_exponent

	clc
	ror FAC2_mantissa+0
	ror FAC2_mantissa+1
	ror FAC2_mantissa+2
	ror FAC2_mantissa+3

	lda FAC1_exponent
	cmp FAC2_exponent
	bne add_align_exponent_FAC2_bit    // branch if next iteration needed

	rts


add_align_exponent_FAC2_zero:

	lda #$00

	sta FAC2_mantissa+0
	sta FAC2_mantissa+1
	sta FAC2_mantissa+2
	sta FAC2_mantissa+3

	lda FAC1_exponent
	sta FAC2_exponent

	rts
