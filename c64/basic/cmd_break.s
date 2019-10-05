cmd_stop:
	ldx #38 // "BREAK"
	jsr print_packed_message

	// Are we in direct mode
	lda CURLIN+1
	cmp #$FF
	beq !+

	// Not direct mode
	ldx #37
	jsr print_packed_message

	lda CURLIN+1
	ldx CURLIN+0
	jsr print_integer

!:
	jsr print_return

cmd_end:
	jmp basic_main_loop
