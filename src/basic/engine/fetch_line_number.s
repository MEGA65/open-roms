// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE

//
// Fetches line number, stores it in LINNUM, sets Carry to indicate failure (not a number), prints SYNTAX ERROR if above 65535
//
// Preserves both .X and .Y
//

fetch_line_number:

	// Fetch the first character (skip spaces), check if 0-9

	jsr fetch_character
	cmp #$20
	beq fetch_line_number

	jsr convert_PETSCII_to_digit
	bcs fetch_line_number_rts

	// First character seems to be correct - store it

	sta LINNUM+0
	lda #$00
	sta LINNUM+1

	// FALLTROUGH

fetch_line_number_loop:

	// Try to fetch another digit

	jsr fetch_character
	jsr convert_PETSCII_to_digit
	bcs fetch_line_number_end

	// We got another digit - store it

	pha

	// Multiply current LINNUM by 10 (x * 10 = (x * 2) + (x * 2) * 4)

	jsr fetch_line_number_mul_LINNUM_2

	lda LINNUM+1
	pha
	lda LINNUM+0
	pha

	jsr fetch_line_number_mul_LINNUM_2
	jsr fetch_line_number_mul_LINNUM_2

	clc
	pla
	adc LINNUM+0
	sta LINNUM+0
	pla
	adc LINNUM+1
	sta LINNUM+1
	bcs_16 do_SYNTAX_error

	// Add the new digit to LINNUM

	pla
	clc
	adc LINNUM+0
	sta LINNUM+0
	lda LINNUM+1
	adc #$00
	sta LINNUM+1
	bcs_16 do_SYNTAX_error

	// Next iteration

#if HAS_OPCODES_65C02
	bra fetch_line_number_loop
#else
	jmp fetch_line_number_loop
#endif

fetch_line_number_end:

	jsr unconsume_character
	clc

	// FALLTROUGH

fetch_line_number_rts:

	rts

fetch_line_number_mul_LINNUM_2:

	asl LINNUM+0
	rol LINNUM+1
	bcs_16 do_SYNTAX_error

	rts
