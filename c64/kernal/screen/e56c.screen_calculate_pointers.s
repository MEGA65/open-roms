#if ROM_LAYOUT_STD || (ROM_LAYOUT_M65 && SEGMENT_KERNAL_0)

//
// Set pointer (PNT) to current screen line , described in:
//
// - [CM64] Computes Mapping the Commodore 64 - page 216
// - http://sta.c64.org/cbm64scrfunc.html
//

// XXX find out what the original ROM really recalculate


screen_calculate_pointers:

	jsr screen_calculate_PNT_USER
	jmp screen_calculate_PNTR_LNMX


#endif // ROM layout
