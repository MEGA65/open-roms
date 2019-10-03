// Clear screen etc, show READY prompt.

basic_warm_start:

#if CONFIG_MEMORY_MODEL_60K
	// We need our helpers to get to filenames under ROMs or IO area
	jsr install_ram_routines
#endif

	// If warm start caused by BRK, print it address
	lda CMP0
	ora CMP0+1
	beq !+

	ldx #32
	jsr print_packed_message

	lda CMP0+1
	jsr print_hex_byte
	lda CMP0+0
	jsr print_hex_byte
	jsr print_return

!:
	jmp basic_main_loop
