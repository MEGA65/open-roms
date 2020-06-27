// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE

//
// Well-known BASIC routine, described in:
//
// - [CM64] Computes Mapping the Commodore 64 - page 212
//
// Prints the start-up messages
//

INITMSG:

#if ROM_LAYOUT_M65

	jsr map_BASIC_1
	jsr_ind VB1__INITMSG
	jmp map_NORMAL

#else

	jmp initmsg_real

#endif
