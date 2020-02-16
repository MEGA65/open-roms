// #LAYOUT# STD *       #TAKE
// #LAYOUT# X16 BASIC_0 #TAKE-OFFSET 2000
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE

//
// Math package - add FAC2 to FAC1
//
// Input:
// - .A - must load FAC1 exponent ($61) beforehand to set the zero flag
//
// Note:
// - load FAC2 after FAC1, or mimic the Kernals sign comparison (XXX do we need it?)
//
// See also:
// - [CM64] Computes Mapping the Commodore 64 - page 112
// - https://www.c64-wiki.com/wiki/Floating_point_arithmetic
// - https://codebase64.org/doku.php?id=base:kernal_floating_point_mathematics
//

// XXX test this

add_FAC2_FAC1:

	// Check if FAC2 is 0; if so leave FAC1 without changes

	lda FAC2_exponent
	beq add_FAC2_FAC1_done

	// If FAC1 is 0, if so just copy FAC2 to FAC1

	lda FAC1_exponent
	beq_16 mov_FAC2_FAC1

	// Make sure the exponents are aligned

	jsr add_align_exponents

	// Check whether signs are the same

	lda FAC1_sign
	eor FAC2_sign

	bmi_16 add_FAC2_FAC1_sub           // branch if signs are opposite

	// Perform the addition
	
	clc
	lda FAC2_mantissa+3
	adc FAC1_mantissa+3
	sta FAC1_mantissa+3

	lda FAC2_mantissa+2
	adc FAC1_mantissa+2
	sta FAC1_mantissa+2
	
	lda FAC2_mantissa+1
	adc FAC1_mantissa+1
	sta FAC1_mantissa+1	

	lda FAC2_mantissa+0
	adc FAC1_mantissa+0
	sta FAC1_mantissa+0	
	
	bcc_16 normal_FAC1                 // end if no need to adapt the exponent

	inc FAC1_exponent
	bne add_FAC2_FAC1_adapt_mantissa   // end if no overflow
	
	lda #$FF
	sta FAC1_exponent
	sta FAC1_mantissa+3
	sta FAC1_mantissa+2
	sta FAC1_mantissa+1
	sta FAC1_mantissa+0	

	// FALLTROUGH

add_FAC2_FAC1_done:

	rts

add_FAC2_FAC1_adapt_mantissa:

	sec
	ror FAC1_mantissa+0
	ror FAC1_mantissa+1
	ror FAC1_mantissa+2
	ror FAC1_mantissa+3
	ror FACOV
	
	rts
