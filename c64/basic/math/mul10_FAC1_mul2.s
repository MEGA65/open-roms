// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE

//
// Multiply FAC1 by 2, do not normalize
//

mul10_FAC1_mul2:

	// First handle the mantissa

	asl FACOV
	rol FAC1_mantissa+3
	rol FAC1_mantissa+2
	rol FAC1_mantissa+1
	rol FAC1_mantissa+0
	bcc !+

	// We need to increment the exponent

	inc FAC1_exponent
	bcs_16 set_FAC1_max

	rts
