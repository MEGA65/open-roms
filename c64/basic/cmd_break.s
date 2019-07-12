cmd_stop:	
basic_do_break:
	jsr printf
	.byte "BREAK",0

	;; Check for direct mode
	;; Are we in direct mode
	lda basic_current_line_number+1
	cmp #$ff
	beq +
	;; Not direct mode
	jsr printf
	.byte " IN ",0
	lda basic_current_line_number+1
	ldx basic_current_line_number+0
	jsr print_integer
	
*
	lda #$0d
	jsr JCHROUT
cmd_end:
	jmp basic_main_loop
	
