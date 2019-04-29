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

	lda basic_current_line_number+1
	cmp #$ff
	beq +

	;; We were in a program, so show IN <line>
	jsr printf
	.byte " IN ",0

	lda basic_current_line_number+1
	ldx basic_current_line_number+0
	jsr print_integer
*
	;; New lines
	lda #$0d
	jsr $ffd2
	lda #$00
	jsr $ffd2

	;; XXX - Restore stack depth first?

	jmp basic_main_loop
	
