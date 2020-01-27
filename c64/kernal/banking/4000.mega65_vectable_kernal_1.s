// #LAYOUT# M65 KERNAL_0 #TAKE-FLOAT
// #LAYOUT# M65 KERNAL_1 #TAKE
// #LAYOUT# *   *        #IGNORE

//
// Definitions for communication with Mega65 segment KERNAL_1 from KERNAL_0
//


#if SEGMENT_KERNAL_0

	// Labels for jumps

	.label VK1__RAMTAS                 = $4000


#else

	// Vector table (OpenROMs private!)

	.word RAMTAS


#endif
