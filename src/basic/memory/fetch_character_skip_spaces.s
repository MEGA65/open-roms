// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE

//
// Fetches a single character, but skips spaces
//


// For these configurations we have optimized version in another file
#if !(ROM_LAYOUT_M65 && (CONFIG_MEMORY_MODEL_46K || CONFIG_MEMORY_MODEL_50K))

fetch_character_skip_spaces:

	jsr fetch_character
	cmp #$20
	beq fetch_character_skip_spaces

	rts


#endif
