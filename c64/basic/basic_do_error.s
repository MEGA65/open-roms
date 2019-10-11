// Compute's Mapping the 64 p93

basic_do_error:
	// Save error number
	phx_trash_a

	// Print ? at start
	jsr print_return
	lda #$3F
	jsr JCHROUT

	// Print main part of error message
	plx_trash_a
	jsr print_packed_message

	// Print ERROR at end
	jsr print_space
	ldx #33
	jsr print_packed_message

	// XXX print IN if not in direct mode

	// XXX print line number if not in direct mode

	jsr print_return
	jsr print_return

	// Reset stack, and go back to main loop
	ldx #$FE
	txs
	jmp basic_main_loop
