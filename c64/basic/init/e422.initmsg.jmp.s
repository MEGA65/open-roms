#if ROM_LAYOUT_STD || (ROM_LAYOUT_M65 && SEGMENT_BASIC_0)

//
// Well-known BASIC routine, described in:
//
// - [CM64] Computes Mapping the Commodore 64 - page 212
//
// Prints the start-up messages
//

INITMSG:
	jmp initmsg_real


#endif // ROM layout
