#if ROM_LAYOUT_STD || (ROM_LAYOUT_M65 && SEGMENT_BASIC_0)


// Consummes a comma in a BASIC code, C set for no coma found

injest_comma:

	jsr basic_fetch_and_consume_character
	cmp #$2C // comma character
	beq injest_comma_found
	cmp #$20 // space, can always be skipped
	beq injest_comma
	
	// not found
	jsr basic_unconsume_character
	sec
	rts

injest_comma_found:
	clc
	rts


#endif // ROM layout
