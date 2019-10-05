
vector_real:

	// Use MEMUSS as temporary storage location - checked on real C64 that this is the
	// address originally used; after calling VECTOR and checking zero page
	// area afterwards, the address could be found there

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
	sty MEMUSS + 1
	stx MEMUSS + 0
	
	// Select routine variant - store or restore vectors
	ldy #$1F
	bcc vector_restore
	
	lda CINV, y
	sta (MEMUSS), y

	bcs vector_end_loop // branch always
	
vector_restore:
	lda (MEMUSS), y
	sta CINV, y

	// FALLTROUGH

vector_end_loop:
	dey
	bpl vector_restore

	// Restore status register (IRQ) before return
	plp
	rts
