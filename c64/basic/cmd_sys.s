cmd_sys:
	
	jsr basic_end_of_statement_check
	bcc +

	;; SYS requires an argument
	jmp do_SYNTAX_ERROR
	
*
	jsr basic_parse_line_number

	;; setup call
	lda #$4c 		;JMP
	sta sys_jmp
	lda basic_line_number+0
	sta sys_jmp+1
	lda basic_line_number+1
	sta sys_jmp+2
	
	;; Setup the register values
	lda sys_reg_p
	pha
	lda sys_reg_a
	ldx sys_reg_x
	ldy sys_reg_y
	plp

	;; Call the routine.
	jsr sys_jmp
	
	jmp basic_execute_statement
