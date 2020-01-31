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

NORMAL:

	lda FAC1_exponent
	beq normal_end                     // branch if our float is 0
	
	lda FAC1_mantissa+3
	beq normal_by_byte                 // branch if we can move the whole byte
	
	and #$80
	bne normal_end                     // branch if already normalized
	
	// FALLTROUGH
	
normal_by_bit:
	
	// First check the current exponent
	
	lda FAC1_exponent
	cmp #$01
	bne !+
	
	// Exponent is 1 - just mark the whole number as 0 and finish
	
	lda #$00
	sta FAC1_exponent
	rts
!:
	// Multiply the mantissa by 2

	clc
	rol FACOV
	rol FAC1_mantissa+3
	rol FAC1_mantissa+2
	rol FAC1_mantissa+1
	rol FAC1_mantissa+0
	
	bcc NORMAL                         // branch if next iteration needed
	rts
	
normal_by_byte:

	// First decrement the exponent by 8, but not below 0
	
	lda FAC1_exponent
	sec
	sbc #$08
	bcs !+
	lda #$00
!:
	sta FAC1_exponent
	beq normal_end                     // branch if our float reached 0

	// Now multiply the mantissa by 8 by moving the whole bytes
	
	lda FAC1_mantissa+2
	sta FAC1_mantissa+3
	lda FAC1_mantissa+1
	sta FAC1_mantissa+2
	lda FAC1_mantissa+0
	sta FAC1_mantissa+1
	
	lda FACOV
	sta FAC1_mantissa+0

	lda #$00
	sta FACOV
	
	// Now check if mantissa is not 0
	
	ora FAC1_mantissa+0
	ora FAC1_mantissa+1
	ora FAC1_mantissa+2
	ora FAC1_mantissa+3
	
	bne NORMAL                         // not 0 - branch to next iteration

	// Our mantissa reached 0 - mark exponent as 0 and finish
	
	sta FAC1_exponent

	// FALLTROUGH

normal_end:

	rts
