#if ROM_LAYOUT_STD || (ROM_LAYOUT_M65 && SEGMENT_BASIC_0)

//
// Well-known BASIC routine, described in:
//
// - [CM64] Computes Mapping the Commodore 64 - page 116, XXX
//


LINPRT:
	// XXX This is temporary, to allow some software to work!
	//     To be replaced by real impleementation.
	jmp print_integer 


#endif // ROM layout
