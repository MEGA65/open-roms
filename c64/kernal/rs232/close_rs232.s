
//
// RS-232 part of the CLOSE routine
//


#if HAS_RS232


#if CONFIG_MEMORY_MODEL_60K
	.error "CONFIG_MEMORY_MODEL_60K is not compatible with RS-232 memory allocation code"
#endif


close_rs232:

	// First check how many RS-232 channels are currently allocated.
	// If more than one, skip deallocation (other channels still uses the buffer).

	jsr rs232_count_channels
	bcs close_rs232_end

	// Deallocate buffer

	inc MEMSIZK+1
	inc MEMSIZK+1

	// XXX is this needed? check with original ROM what it actually does

	lda #$00
	sta ROBUF+0
	sta ROBUF+1
	sta RIBUF+0
	sta RIBUF+1

close_rs232_end:

	jmp close_remove_from_table


#endif // HAS_RS232
