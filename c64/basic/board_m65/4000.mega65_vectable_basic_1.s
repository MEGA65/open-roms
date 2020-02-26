// #LAYOUT# M65 BASIC_0 #TAKE-FLOAT
// #LAYOUT# M65 BASIC_1 #TAKE
// #LAYOUT# *   *       #IGNORE

//
// Definitions for communication with Mega65 segment BASIC_1 from BASIC_0
//


#if SEGMENT_BASIC_0

	// Label definitions

	.label VB1__INITMSG                = $4000 + 2 * 0
	.label VB1__list_single_line       = $4000 + 2 * 1

#else

	// Vector table (OpenROMs private!)

	.word INITMSG
	.word list_single_line

#endif
