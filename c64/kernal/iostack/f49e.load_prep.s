#if ROM_LAYOUT_STD || (ROM_LAYOUT_M65 && SEGMENT_KERNAL_0)

//
// LOAD preparation routine
//

//
// Input (according to http://sta.c64.org/cbm64krnfunc.html)
// .A        - 0 for load, non-0 for verify
// .X and .Y - load address (if secondary address is 0)
//

//
// Note: Although the vector at $330 points to $F4A5, the Kernal jump table points to $F49E
// (see also Mapping the C64, page 76). By experimenting I have discovered that $F49E performs
// indirect jump via ($0330) vector, after setting MEMUSS.
//


LOAD_PREP:

	sty MEMUSS+1
	stx MEMUSS+0
    jmp (ILOAD)


#endif // ROM layout
