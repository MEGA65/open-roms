
//
// Note: Although the vector at $330 points to $F4A5, the Kernal jump table points to $F49E
// (see also Mapping the C64, page 76). By experimenting I have discovered that $F49E performs
// indirect jump via ($0330) vector, after setting MEMUSS.
//

LOAD_INT:

	sty MEMUSS+1
	stx MEMUSS+0
    jmp (ILOAD)
