// #LAYOUT# M65 KERNAL_0 #TAKE-FLOAT
// #LAYOUT# M65 KERNAL_1 #TAKE
// #LAYOUT# *   *        #IGNORE

//
// Definitions for communication with Mega65 segment KERNAL_1
//


#if SEGMENT_KERNAL_0

	// Labels for jumps


	.label KERNAL_1__TESTROUTINE = $4000


#elif

	// Jumptable (OpenROMs private!)


	jmp TESTROUTINE


TESTROUTINE:

	rts


#endif
