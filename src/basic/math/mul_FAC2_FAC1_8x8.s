// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE

//
// Helper routine, based on code by djmips (fast version) from:
// - https://codebase64.org/doku.php?id=base:8bit_multiplication_16bit_product_fast_no_tables
// or by code by Graham (small version) from:
// - https://codebase64.org/doku.php?id=base:short_8bit_multiplication_16bit_product
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

#if !HAS_SMALL_BASIC

	// Fast multiplication routine

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

#else

	// Small multiplication routine

	lda #$00
	ldx #$08
	clc
!:
	bcc !+
	clc
	adc INDEX+3
!:
	ror
	ror INDEX+2
	dex
	bpl !--
 	ldx INDEX+2

 	// Reverse return byte order, to match fast version
 	// (such order is easier top handle for the callers)

 	stx INDEX+2
 	tax
 	lda INDEX+2 

#endif

	clc
	rts

mul_FAC2_FAC1_8x8_zero:

	lda #$00
	tax

	clc
	rts
