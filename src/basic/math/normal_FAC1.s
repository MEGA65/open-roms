// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE

//
// Math package - normalize FAC1
//
// See also:
// - [CM64] Computes Mapping the Commodore 64 - page 113
// - https://www.c64-wiki.com/wiki/Floating_point_arithmetic
// - https://codebase64.org/doku.php?id=base:kernal_floating_point_mathematics
//

// XXX test this

normal_FAC1:

	lda FAC1_exponent
	beq normal_FAC1_end                     // branch if our float is 0
	
	// FALLTROUGH

normal_FAC1_check_mantissa_byte:

	lda FAC1_mantissa+0
	beq normal_FAC1_by_byte                 // branch if we can move the whole byte
	
	// FALLTROUGH

normal_FAC1_check_mantissa_bit:

	lda FAC1_mantissa+0                     // XXX optimize for 65CE02?
	and #$80
	bne normal_FAC1_end                     // branch if already normalized
	
	// FALLTROUGH
	
normal_FAC1_by_bit:
	
	// Decrement the exponent
	
	dec FAC1_exponent
	beq normal_FAC1_end                     // exponent reached 0, nothing more to do

	// Multiply the mantissa by 2

	asl FACOV
	rol FAC1_mantissa+3
	rol FAC1_mantissa+2
	rol FAC1_mantissa+1
	rol FAC1_mantissa+0
	
	bcc normal_FAC1_check_mantissa_bit      // branch if next iteration needed
	rts
	
normal_FAC1_by_byte:

	// First decrement the exponent by 8, but not below 0
	
	lda FAC1_exponent
	sec
	sbc #$08
	bcs !+
	lda #$00
!:
	sta FAC1_exponent
	beq normal_FAC1_end                      // branch if our float reached 0

	// Now multiply the mantissa by 8 by moving the whole bytes
	
	lda FAC1_mantissa+1
	sta FAC1_mantissa+0
	lda FAC1_mantissa+2
	sta FAC1_mantissa+1
	lda FAC1_mantissa+3
	sta FAC1_mantissa+2
	
	lda FACOV
	sta FAC1_mantissa+3

	lda #$00
	sta FACOV
	
	// Now check if mantissa is not 0
	
	ora FAC1_mantissa+0
	ora FAC1_mantissa+1
	ora FAC1_mantissa+2
	ora FAC1_mantissa+3
	
	bne normal_FAC1_check_mantissa_byte     // not 0 - branch to next iteration

	// Our mantissa reached 0 - mark exponent as 0 and finish
	
	sta FAC1_exponent

	// FALLTROUGH

normal_FAC1_end:

	rts
