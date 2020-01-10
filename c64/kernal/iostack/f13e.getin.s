#if ROM_LAYOUT_STD || (ROM_LAYOUT_M65 && SEGMENT_KERNAL_0)

//
// Official Kernal routine, described in:
//
// - [RG64] C64 Programmers Reference Guide   - page 283
// - [CM64] Computes Mapping the Commodore 64 - page 227/228
//
// CPU registers that has to be preserved (see [RG64]): for RS-232: .X, .Y
//


GETIN:
	jmp getin_real


#endif // ROM layout
