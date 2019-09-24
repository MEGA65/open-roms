
vector_real:

	// Temporary storage location - checked on real C64 that this is the
	// address originally used; after calling VECTOR and checking zero page
	// area afterwards, the address could be found there
	.label _caller_arr_ptr = MEMUSS

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
	
	lda CINV, y
	sta (_caller_arr_ptr), y

	bcs vector_end_loop // branch always
	
vector_restore:
	lda (_caller_arr_ptr), y
	sta CINV, y

	// FALLTROUGH

vector_end_loop:
	dey
	bpl vector_restore

	// Restore status register (IRQ) before return
	plp
	rts
