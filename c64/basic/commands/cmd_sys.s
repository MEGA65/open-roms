cmd_sys:
	
	jsr basic_end_of_statement_check
	bcc !+

	// SYS requires an argument
	jmp do_SYNTAX_error
	
!:
	//
	// XXX Temporary ugly hack to support 'SYS PI*656'
	//

	ldy #$00

cmd_sys_hack_loop:
	lda (TXTPTR), y
	cmp cmd_sys_hack_str, y
	bne cmd_sys_hack_not_needed
	lda (TXTPTR), y
	beq cmd_sys_hack_apply
	iny
	bne cmd_sys_hack_loop // branch always

cmd_sys_hack_apply:

	lda #<2060
	sta LINNUM+0
	lda #>2060
	sta LINNUM+1
	bne cmd_sys_setup_call // always jumps

cmd_sys_hack_not_needed:

	//
	// XXX End of hack
	//

	jsr basic_parse_line_number

cmd_sys_setup_call:
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


	//
	// XXX Temporary ugly hack to support 'SYS PI*656'
	//

cmd_sys_hack_str:
	.byte $FF, $AC, $36, $35, $36, $00
