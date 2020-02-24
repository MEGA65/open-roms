// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE

//
// Math package - multiplies FAC1 by FAC2
//
// Input:
// - .A - must load FAC1 exponent ($61) beforehand to set the zero flag
//
// Note:
// - load FAC2 after FAC1, or mimic the Kernals sign comparison (XXX do we need it?)
//
// See also:
// - [CM64] Computes Mapping the Commodore 64 - page 113 XXX address does not match
// - https://www.c64-wiki.com/wiki/Floating_point_arithmetic
// - https://codebase64.org/doku.php?id=base:kernal_floating_point_mathematics
//

// XXX provide implementation

mul_FAC2_FAC1:

	// First handle special case of multiplying by 0
	
	lda FAC1_exponent
	beq mul_FAC2_FAC1_done
	
	lda FAC2_exponent
	bne !+
	sta FAC1_exponent
	beq mul_FAC2_FAC1_done
!:
	// Multiply signs
	
	lda FAC1_sign
	eor FAC2_sign
	sta FAC1_sign
	
	// Check if exponents can be added without overflow/underflow
	
	lda FAC1_exponent
	and #$80
	eor FAC2_exponent
	
	bmi mul_FAC2_FAC1_add_exponents    // exponent signs are opposite, we can add them safely
	
	// Both exponents are either negative (below $80), or both are non-negative ($80 or above),
	// try to add them
	
	lda FAC1_exponent
	clc
	adc FAC2_exponent
	bpl mul_FAC2_FAC1_sub_exp_bias     // branch if we can add values
	
	// We cannot add them, result would over/underflow; set result as
	// either 0 or maximum possible float
	
	lda FAC1_exponent
	bmi_16 set_FAC1_max

	lda #$00
	sta FAC1_exponent
	rts
	
mul_FAC2_FAC1_add_exponents:
	
	// Add the exponents
	
	lda FAC1_exponent
	clc
	adc FAC2_exponent
	
	// FALLTROUGH
	
mul_FAC2_FAC1_sub_exp_bias:
	
	sec
	sbc #$80                           // bias
	sta FAC1_exponent
	
	// Multiply the mantissas
	
	// XXX

	STUB_IMPLEMENTATION()

mul_FAC2_FAC1_done:

	rts


mul_8x8: // XXX we should probably move this subroutine to separate file

	// Routine based on code by djmips, taken from:
	// - https://codebase64.org/doku.php?id=base:8bit_multiplication_16bit_product_fast_no_tables
	//
	// input: mul1, mul2
	// optput: .A (high byte), mul1 (low byte)

.label mul1 = INDEX+2
.label mul2 = INDEX+3

	lda #$00

	dec mul2	// decrement because we will be adding with carry set for speed (an extra one)
	ror mul1
	bcc !+
	adc mul2
!:
	ror
	ror mul1
	bcc !+
	adc mul2
!:
	ror
	ror mul1
	bcc !+
	adc mul2
!:
	ror
	ror mul1
	bcc !+
	adc mul2
!:
	ror
	ror mul1
	bcc !+
	adc mul2
!:
	ror
	ror mul1
	bcc !+
	adc mul2
!:
	ror
	ror mul1
	bcc !+
	adc mul2
!:
	ror
	ror mul1
	bcc !+
	adc mul2
!:
	ror
	ror mul1
	inc mul2

	rts
