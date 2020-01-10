#if ROM_LAYOUT_STD || (ROM_LAYOUT_M65 && SEGMENT_KERNAL_0)

//
// Official Kernal routine, described in:
//
// - [RG64] C64 Programmers Reference Guide   - page 287/288
// - [CM64] Computes Mapping the Commodore 64 - page 240
//
// CPU registers that has to be preserved (see [RG64]): .A
//

MEMBOT:

	bcc membot_set
	
	ldy MEMSTR+1
	ldx MEMSTR+0

	// FALLTROUGH

membot_set:

	sty MEMSTR+1
	stx MEMSTR+0
	
	rts


#endif // ROM layout
