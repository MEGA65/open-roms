cmd_sys:
	
	jsr basic_end_of_statement_check
	bcc !+

	// SYS requires an argument
	jmp do_SYNTAX_error
	
!:
	jsr basic_parse_line_number

	// setup call
	lda #$4C // JMP opcode
	sta USRPOK
	lda LINNUM+0
	sta USRADD+0
	lda LINNUM+1
	sta USRADD+1
	
	// Setup the register values
	lda SPREG
	pha
	ldy SYREG
	ldx SXREG
	lda SAREG
	plp

	// Call the routine.
	jsr USRPOK
	
	jmp basic_execute_statement
