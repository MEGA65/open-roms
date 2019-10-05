
//
// Official Kernal routine, described in:
//
// - [RG64] C64 Programmer's Reference Guide   - page 293 (RESTOR), 304 (VECTOR)
// - [CM64] Compute's Mapping the Commodore 64 - page 237
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
