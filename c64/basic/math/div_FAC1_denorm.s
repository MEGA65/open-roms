// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE

//
// Math package - denormalize FAC1 mantissa and adapt its exponent accordingly,
// so that division is more precise
//

// XXX test this

div_FAC1_denorm:

	// Start by moving whole bytes, if possible

	lda FACOV
	bne div_FAC1_denorm_by_bit         // branch if last byte of mantissa is non-zero

	lda FAC1_exponent
	cmp #$09
	bcc div_FAC1_denorm_by_bit         // branch if not suitable to decrement exponent by 8

	// Decrement exponent

	sbc #$08                           // Carry already set here
	sta FAC1_exponent

	// Move mantissa bytes

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

	beq div_FAC1_denorm                // branch always

div_FAC1_denorm_by_bit:

	lda FACOV
	and #$01
	bne div_FAC1_denorm_done           // branch if lowest bit of mantissa is already 1

	lda FAC1_exponent
	cmp #$02
	bcc div_FAC1_denorm_done           // branch if not suitable to decrement exponent

	// Decrement exponent

	dec FAC1_exponent

	// Move mantissa bits

	clc
	ror FAC1_mantissa+0
	ror FAC1_mantissa+1
	ror FAC1_mantissa+2
	ror FAC1_mantissa+3
	ror FACOV

	bcc div_FAC1_denorm_by_bit         // branch always

div_FAC1_denorm_done:

	rts
