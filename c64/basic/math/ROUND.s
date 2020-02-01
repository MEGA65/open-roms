// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE

//
// Math package - rounds FAC1 before copying
//
// See also:
// - [CM64] Computes Mapping the Commodore 64 - page 115
// - https://codebase64.org/doku.php?id=base:kernal_floating_point_mathematics
//

// XXX test this

ROUND:

	// If number is 0, do not do anything

	lda FAC1_exponent
	beq round_done

	lda FACOV
	bpl round_zero_FACOV                 // branch if it is enough to clear FACOV

	// Increment the 4 bytes of matissa

	// Curse you, who invented this format! Had the mantissa been little endian,
	// we could have used INW on 65C02 and above, the code would have been smaller!

	inc FAC1_mantissa+3
	bne round_zero_FACOV
	inc FAC1_mantissa+2
	bne round_zero_FACOV
	inc FAC1_mantissa+1
	bne round_zero_FACOV
	inc FAC1_mantissa+0
	bne round_zero_FACOV

	// If we are here, it means mantissa is 0; put it to minimum allowed and increment exponent

	lda #$80
	sta FAC1_mantissa+0
	inc FAC1_exponent
	bne round_zero_FACOV

	// If we are here, it means the exponent wrapped around to $00; put it back to $FF

	dec FAC1_exponent

	// FALLTROUGH

round_zero_FACOV:

	lda #$00
	sta FACOV

	// FALLTROUGH

round_done:

	rts
