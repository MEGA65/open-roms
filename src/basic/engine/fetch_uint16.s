// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE

//
// Fetches unsigned 16-bit integer, stores it in LINNUM, sets Carry to indicate failure (not a number)
//
// If value above 65535, error depends on .A opn entry
//
// Preserves both .X and .Y
//

fetch_uint16:

	// Push the error code to stack

	pha

	// Fetch the first character (skip spaces), check if 0-9

	jsr fetch_character_skip_spaces

	jsr convert_PETSCII_to_digit
	bcs fetch_uint16_rts

	// First character seems to be correct - store it

	sta LINNUM+0
	lda #$00
	sta LINNUM+1

	// FALLTROUGH

fetch_uint16_loop:

	// Try to fetch another digit

	jsr fetch_character
	jsr convert_PETSCII_to_digit
	bcs fetch_uint16_end

	// We got another digit - store it

	pha

	// Multiply current LINNUM by 10 (x * 10 = (x * 2) + (x * 2) * 4)

	jsr fetch_uint16_mul_LINNUM_2
	bcs fetch_uint16_1PLA_error

	lda LINNUM+1
	pha
	lda LINNUM+0
	pha

	jsr fetch_uint16_mul_LINNUM_2
	bcs fetch_uint16_3PLA_error
	jsr fetch_uint16_mul_LINNUM_2
	bcs fetch_uint16_3PLA_error

	clc
	pla
	adc LINNUM+0
	sta LINNUM+0
	pla
	adc LINNUM+1
	sta LINNUM+1
	bcs fetch_uint16_1PLA_error

	// Add the new digit to LINNUM

	pla
	clc
	adc LINNUM+0
	sta LINNUM+0
	lda LINNUM+1
	adc #$00
	sta LINNUM+1
	bcs fetch_uint16_error

	// Next iteration

#if HAS_OPCODES_65C02
	bra fetch_uint16_loop
#else
	jmp fetch_uint16_loop
#endif

fetch_uint16_end:

	jsr unconsume_character
	clc

	// FALLTROUGH

fetch_uint16_rts:

	pla
	rts

fetch_uint16_mul_LINNUM_2:

	asl LINNUM+0
	rol LINNUM+1

	rts

fetch_uint16_3PLA_error:

	pla
	pla

	// FALLTROUGH

fetch_uint16_1PLA_error:

	pla

	// FALLTROUGH

fetch_uint16_error:

	plx_trash_a
	jmp do_basic_error
