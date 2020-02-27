// #LAYOUT# M65 BASIC_0 #TAKE-FLOAT
// #LAYOUT# M65 BASIC_1 #TAKE
// #LAYOUT# *   *       #IGNORE

//
// Definitions for communication with Mega65 segment BASIC_1 from BASIC_0
//


#if SEGMENT_BASIC_0

	// Label definitions

	.label VB1__INITMSG                = $4000 + 2 * 0
	.label VB1__LINKPRG                = $4000 + 2 * 1
	.label VB1__tokenise_line          = $4000 + 2 * 2
	.label VB1__list_single_line       = $4000 + 2 * 3
	.label VB1__print_packed_message   = $4000 + 2 * 4
	.label VB1__basic_do_clr           = $4000 + 2 * 5
	.label VB1__basic_do_new           = $4000 + 2 * 6

#else

	// Vector table (OpenROMs private!)

	.word INITMSG
	.word LINKPRG
	.word tokenise_line
	.word list_single_line
	.word print_packed_message
	.word basic_do_clr
	.word basic_do_new

#endif
