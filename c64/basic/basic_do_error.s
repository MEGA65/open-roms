// Compute's Mapping the 64 p93

basic_do_error:
	// Save error number
	txa
	pha

	// Print ? at start
	lda #$0D
	jsr JCHROUT
	lda #$3F
	jsr JCHROUT

	// Print main part of error message
	pla
	tax
	jsr print_packed_message

	// Print ERROR at end
	lda #$20
	jsr JCHROUT
	ldx #33
	jsr print_packed_message

	// XXX print IN if not in direct mode

	// XXX print line number if not in direct mode

	lda #$0D
	jsr JCHROUT
	lda #$0D // XXX do we need this?
	jsr JCHROUT

	// Reset stack, and go back to main loop
	ldx #$FE
	txs
	jmp basic_main_loop
