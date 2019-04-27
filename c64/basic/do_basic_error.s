	;; Error # in X

do_basic_error:
	;; "?"
	txa
	pha
	lda #$0d
	jsr $ffd2
	lda #$3f
	jsr $ffd2
	pla
	tax

	;; Error message text
	jsr print_packed_message

	;; A space between error name and word error
	lda #$20
	jsr $ffd2
	
	;; "ERROR"
	ldx #33
	jsr print_packed_message

	;; New lines
	lda #$0d
	jsr $ffd2
	lda #$00
	jsr $ffd2

	;; XXX - Restore stack depth first?

	jmp basic_main_loop
	
