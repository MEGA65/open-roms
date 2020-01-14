
//
// Definitions for communication with Mega65 segment KERNAL_1
//


#if (ROM_LAYOUT_M65 && SEGMENT_KERNAL_0)

	// Labels for jumps


.label KERNAL_1__TESTROUTINE = $4000


#elif (ROM_LAYOUT_M65 && SEGMENT_KERNAL_1)

	// Jumptable (OpenROMs private!)


	jmp TESTROUTINE


TESTROUTINE:

	rts


#endif
