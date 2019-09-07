
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
	ldx #<vector_defaults
	ldy #>vector_defaults

	// FALLTHROUGH

VECTOR:

	// Temporary storage location - checked on real C64 that this is the
	// address originally used; after calling VECTOR and checking zero page
	// area afterwards, the address could be found there
	.label _caller_arr_ptr = MEMUS

	// According to 'Compute's Mapping the Commodore 64' page 237,
	// the CBM implementation does not disable IRQs - yet, the
	// 'C64 Programmers Reference Guide' does not contain such
	// warning and does not mention any preparations needed, so...
	// better safe than sorry, disable the IRQ for the duration
	// of vector manipulation
	php
	cli
	
	// Prepare the user data pointer - strange order to reduce risk
	// of potential similarity to the original routine
	sty _caller_arr_ptr + 1
	stx _caller_arr_ptr + 0
	
	// Select routine variant - store or restore vectors
	ldy #$1F
	bcc vector_restore
	
	// FALLTHROUGH
	
vector_store:
	lda CINV, y
	sta (_caller_arr_ptr), y
	dey
	bpl vector_store
	
	// Restore status register (IRQ) before return
	plp
	rts
	
vector_restore:
	lda (_caller_arr_ptr), y
	sta CINV, y
	dey
	bpl vector_restore

	// Restore status register (IRQ) before return
	plp
	rts
