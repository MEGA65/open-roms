// #LAYOUT# M65 BASIC_0 #TAKE-FLOAT
// #LAYOUT# M65 BASIC_1 #TAKE
// #LAYOUT# *   *       #IGNORE

//
// Definitions for communication with Mega65 segment BASIC_1 from BASIC_0
//


#if SEGMENT_BASIC_0

	// Label definitions

	.label VB1__TEST                   = $4000 + 2 * 0

TEST:

	jsr map_BASIC_1
	jmp (VB1__TEST)

#else

	// Vector table (OpenROMs private!)

	.word TEST


TEST:

	inc 53280
	inc 53281

	jmp map_NORMAL

#endif
