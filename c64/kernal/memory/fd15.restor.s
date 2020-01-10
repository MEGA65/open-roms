#if ROM_LAYOUT_STD || (ROM_LAYOUT_M65 && SEGMENT_KERNAL_0)

//
// Official Kernal routine, described in:
//
// - [RG64] C64 Programmers Reference Guide   - page 293 (RESTOR), 304 (VECTOR)
// - [CM64] Computes Mapping the Commodore 64 - page 237
//
// CPU registers that has to be preserved (see [RG64]): none
//

RESTOR:

	clc // clear carry - for writing to system table
	ldy #>vector_defaults
	ldx #<vector_defaults

	// FALLTHROUGH

VECTOR:

// Our implementation is longer than the original one,
// placing it here would cause a collision with VECTOR defaults

	jmp vector_real


#endif // ROM layout
