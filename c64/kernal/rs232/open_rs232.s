
//
// RS-232 part of the OPEN routine
//


#if HAS_RS232


#if CONFIG_MEMORY_MODEL_60K
	.error "CONFIG_MEMORY_MODEL_60K is not compatible with RS-232 memory allocation code"
#endif


open_rs232:

	// First check how many RS-232 channels are currently allocated.
	// If more than one, skip allocation (already allocated).

	jsr rs232_count_channels
	bcs open_rs232_end

	// Allocate buffers - first RIBUF, afterwards ROBUF
	// (checked addresses on original ROMs)

	lda MEMSIZK+0
	sta ROBUF+0
	sta RIBUF+0

	dec MEMSIZK+1
	lda MEMSIZK+1
	sta RIBUF+1

	dec MEMSIZK+1
	lda MEMSIZK+1
	sta ROBUF+1

	// Initialize buffer indexes

	lda #$00
	sta RIDBE
	sta RIDBS
	sta RODBS
	sta RODBE

open_rs232_end:

	jmp open_done_success


#endif // HAS_RS232
