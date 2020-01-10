#if ROM_LAYOUT_STD || (ROM_LAYOUT_M65 && SEGMENT_KERNAL_0)

//
// Official Kernal routine, described in:
//
// - [RG64] C64 Programmers Reference Guide   - page 300
// - [CM64] Computes Mapping the Commodore 64 - page 239
//
// CPU registers that has to be preserved (see [RG64]): .A, .X, .Y
//


SETTMO:
	sta TIMOUT
	rts


#endif // ROM layout
