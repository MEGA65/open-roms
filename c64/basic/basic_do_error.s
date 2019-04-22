	;; Compute's Mapping the 64 p93

basic_do_error:
	;; Save error number
	txa
	pha

	;; Print ? at start
	lda #$0d
	jsr $ffd2
	lda #$3f
	jsr $ffd2

	;; Print main part of error message
	pla
	tax
	jsr print_packed_message

	;; Print ERROR at end
	lda #$20
	jsr $ffd2
	ldx #33
	jsr print_packed_message

	;; XXX print IN if not in direct mode

	;; XXX print line number if not in direct mode

	lda #$0d
	jsr $ffd2
	lda #$0d
	jsr $ffd2

	;; Reset stack, and go back to main loop
	ldx #$fe
	txs
	jmp basic_main_loop



