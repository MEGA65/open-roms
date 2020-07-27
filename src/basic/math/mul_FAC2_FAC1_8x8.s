// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE

//
// Helper routine, based on code by djmips from:
// - https://codebase64.org/doku.php?id=base:8bit_multiplication_16bit_product_fast_no_tables
//
// input: .A (and Zero flag set according to .A), INDEX+3
// output: .X (high byte), .A (low byte), carry always clear
//

mul_FAC2_FAC1_8x8:

	// Special cases - handle multiplication by 0

	beq mul_FAC2_FAC1_8x8_zero
	sta INDEX+2

	lda INDEX+3
	beq mul_FAC2_FAC1_8x8_zero

	// Multiply INDEX+2 * INDEX+3

	lda #$00

	dec INDEX+3	// decrement because we will be adding with carry set for speed (an extra one)
	ror INDEX+2
	bcc !+
	adc INDEX+3
!:
	ror
	ror INDEX+2
	bcc !+
	adc INDEX+3
!:
	ror
	ror INDEX+2
	bcc !+
	adc INDEX+3
!:
	ror
	ror INDEX+2
	bcc !+
	adc INDEX+3
!:
	ror
	ror INDEX+2
	bcc !+
	adc INDEX+3
!:
	ror
	ror INDEX+2
	bcc !+
	adc INDEX+3
!:
	ror
	ror INDEX+2
	bcc !+
	adc INDEX+3
!:
	ror
	ror INDEX+2
	bcc !+
	adc INDEX+3
!:
	ror
	ror INDEX+2
	inc INDEX+3

	tax
	lda INDEX+2

	clc
	rts

mul_FAC2_FAC1_8x8_zero:

	lda #$00
	tax

	clc
	rts
