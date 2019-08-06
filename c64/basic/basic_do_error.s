	;; Compute's Mapping the 64 p93

basic_do_error:
	;; Save error number
	txa
	pha

	;; Print ? at start
	lda #$0d
	jsr via_IBSOUT
	lda #$3f
	jsr via_IBSOUT

	;; Print main part of error message
	pla
	tax
	jsr print_packed_message

	;; Print ERROR at end
	lda #$20
	jsr via_IBSOUT
	ldx #33
	jsr print_packed_message

	;; XXX print IN if not in direct mode

	;; XXX print line number if not in direct mode

	lda #$0d
	jsr via_IBSOUT
	lda #$0d
	jsr via_IBSOUT

	;; Reset stack, and go back to main loop
	ldx #$fe
	txs
	jmp basic_main_loop



