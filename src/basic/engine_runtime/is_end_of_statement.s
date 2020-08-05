// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE

//
// Check for end of statement, sets Carry if so. Injests all spaces.
//


is_end_of_statement:

	jsr fetch_character_skip_spaces

	cmp #$00
	beq !+
	cmp #$3A
	beq !+

	// Not end of statement

#if !HAS_OPCODES_65CE02
	jsr unconsume_character
#else
	dew TXTPTR
#endif

	clc
	rts
!:
	// End of statement

#if !HAS_OPCODES_65CE02
	jsr unconsume_character
#else
	dew TXTPTR
#endif

	sec
	rts
