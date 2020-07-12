// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE

//
// Works similar to $BDCD in original C64 BASIC
//

print_integer:

	// Tested with original C64 ROMs, that it trashes FAC1 too

	sta FAC1_exponent+1
	stx FAC1_exponent+0

	// Check for 0

	ora FAC1_exponent+0
	bne print_integer_not_0

	// Just print '0' and quit

	lda #$30
	jmp JCHROUT

print_integer_not_0:

	// Try to find the index of the first digit

	ldy #$04
!:
	jsr print_integer_compare
	bcs print_integer_digit

	dey
	bpl !-                             // branch always

print_integer_digit:

	// Determine digit to print

	ldx #$00
!:
	jsr print_integer_compare
	bcc !+

	// Raise digit, lower the integer

	inx

	sec
	lda FAC1_exponent+0
	sbc print_integer_tab_lo, y
	sta FAC1_exponent+0
	lda FAC1_exponent+1
	sbc print_integer_tab_hi, y
	sta FAC1_exponent+1
	
	bcs !-                             // branch always
!:
	// Convert digit in .X to PETSCII in .A and print it out

	txa
	clc
	adc #$30

	jsr JCHROUT

	// Check if next iteration is needed

	dey
	bpl print_integer_digit

	// The end

	rts
