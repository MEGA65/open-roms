#if ROM_LAYOUT_STD || (ROM_LAYOUT_M65 && SEGMENT_KERNAL_0)

//
// Official Kernal routine, described in:
//
// - [RG64] C64 Programmers Reference Guide   - page 280
// - [CM64] Computes Mapping the Commodore 64 - page 242
//
// CPU registers that has to be preserved (see [RG64]): none
//

CINT:

	jsr cint_legacy
	jmp setup_pal_ntsc


#endif // ROM layout
