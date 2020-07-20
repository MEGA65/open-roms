// #LAYOUT# STD *       #TAKE
// #LAYOUT# M65 BASIC_1 #TAKE
// #LAYOUT# X16 BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE

//
// Helper table for 'MEM' command - list of subtrahend zeropage variables
//

#if !HAS_SMALL_BASIC

helper_mem_tab_y:

	.byte STREND
	.byte FRETOP
	.byte ARYTAB
	.byte VARTAB
	.byte TXTTAB

#endif
