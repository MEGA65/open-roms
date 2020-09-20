;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

;
; Tries to execute the statement, and all the subsequent ones
;


execute_statements:

	; Check for RUN/STOP

	lda STKEY
	+bpl cmd_stop

	; Skip over any white spaces and colons (':')
@1:
	jsr fetch_character_skip_spaces
	cmp #$3A                           ; colon, can be skipped
	beq @1
	
	; Check if end of the line

	cmp #$00
	beq execute_statements_end_of_line

	; Not end of the line - it seems we actually have something to execute	

	; Move token code to .X
	tax

	; Push the 'end_of_statement' address for RTS

	lda #>(end_of_statement - 1)
	pha
	lda #<(end_of_statement - 1)
	pha

	; Check if token is valid for execution

!ifdef HAS_SMALL_BASIC {

	cpx #$01
	beq execute_statements_01

} else {

!ifdef CONFIG_MB_M65 {
	cpx #$04
} else {
	cpx #$03
}
	bcc execute_statements_extended
}

	cpx #$CB                                     
	+beq cmd_go                                  ; 'GO' command has a strange token, placed after function tokens

	cpx #$7F
	+bcc execute_statements_var_assign         ; not a token - try variable assign

	cpx #$A7
	+bcs do_SYNTAX_error

!ifndef HAS_OPCODES_65C02 {

	; Get the jump table entry for it, push it on the stack, and then RTS to start it.

	lda command_jumptable_hi - $80, x
	pha
	lda command_jumptable_lo - $80, x
	pha
	
	rts

} else { ; HAS_OPCODES_65C02

	; Use jumptable to go to the command routine

	txa
	asl
	tax
	jmp (command_jumptable, x)
}

!ifndef HAS_SMALL_BASIC {

execute_statements_extended:

	; Support for extended BASIC commands

	; XXX consider jumpable here

	cpx #$01
	beq execute_statements_01

	cpx #$02
	beq execute_statements_02

!ifdef CONGIH_MB_M65 {

	cpx #$03
	beq execute_statements_03
}

	jmp do_SYNTAX_error
}

execute_statements_01:

	; Get the sub-token, check that it is valid

	jsr fetch_character
	cmp #$00
	+beq do_SYNTAX_error

	cmp #(TK__MAXTOKEN_keywords_01+1)
	+bcs do_SYNTAX_error

	; Execute command

!ifndef HAS_OPCODES_65C02 {

	; Get the jump table entry for it, push it on the stack, and then RTS to start it.

	tax
	lda command_01_jumptable_hi - 1, x
	pha
	lda command_01_jumptable_lo - 1, x
	pha
	
	rts

} else { ; HAS_OPCODES_65C02

	; Use jumptable to go to the command routine

	asl
	tax
	jmp (command_01_jumptable - 2, x)
}

!ifndef HAS_SMALL_BASIC {

execute_statements_02:

	; Get the sub-token, check that it is valid

	jsr fetch_character
	cmp #$00
	+beq do_SYNTAX_error

	cmp #(TK__MAXTOKEN_keywords_02+1)
	+bcs do_SYNTAX_error

	; Execute command

!ifndef HAS_OPCODES_65C02 {

	; Get the jump table entry for it, push it on the stack, and then RTS to start it.

	tax
	lda command_02_jumptable_hi - 1, x
	pha
	lda command_02_jumptable_lo - 1, x
	pha
	
	rts

} else { ; HAS_OPCODES_65C02

	; Use jumptable to go to the command routine

	asl
	tax
	jmp (command_02_jumptable - 2, x)
}

} ; !HAS_SMALL_BASIC

!ifdef CONFIG_MB_M65 {

execute_statements_03:

	; Get the sub-token, check that it is valid

	jsr fetch_character
	cmp #$00
	+beq do_SYNTAX_error

	cmp #(TK__MAXTOKEN_keywords_03+1)
	+bcs do_SYNTAX_error

	; Use jumptable to go to the command routine

	asl
	tax
	jmp (command_03_jumptable - 2, x)

} ; CONFIG_MB_M65

execute_statements_end_of_line:

	; First check, if we are in direct mode - if so,
	; end the execution and go to main loop

	ldx CURLIN+1
	inx
	+beq shell_main_loop

	; Advance to the next line - first copy the line number
	; to previous line number

	lda CURLIN+0
	sta OLDLIN+0
	lda CURLIN+1
	sta OLDLIN+1
		
	; Advance the basic line pointer to the next line; if end,
	; go to the main loop

	jsr follow_link_to_next_line

	lda OLDTXT+0
	ora OLDTXT+1
	+beq shell_main_loop
	
	; FALLTROUGH

execute_line:

	; Check if pointer is null, if so, we are at the end of the program

	jsr is_line_pointer_null
	+beq shell_main_loop             ; branch if end of program reached

	; Skip pointer and line number to get address of first statement

	lda OLDTXT+0
	clc
	adc #$04
	sta TXTPTR+0
	lda OLDTXT+1
	adc #$00
	sta TXTPTR+1

	ldy #$02

!ifdef CONFIG_MEMORY_MODEL_60K {
	ldx #<OLDTXT
	jsr peek_under_roms
} else ifdef CONFIG_MEMORY_MODEL_46K_OR_50K {
	jsr peek_under_roms_via_OLDTXT ; XXX! speed-optimize - combine whole flow into one routine
} else { ; CONFIG_MEMORY_MODEL_38K
	lda (OLDTXT),y
}

	sta CURLIN+0
	iny

!ifdef CONFIG_MEMORY_MODEL_60K {
	jsr peek_under_roms
} else ifdef CONFIG_MEMORY_MODEL_46K_OR_50K {
	jsr peek_under_roms_via_OLDTXT
} else { ; CONFIG_MEMORY_MODEL_38K
	lda (OLDTXT),y
}

	sta CURLIN+1

	jmp execute_statements


execute_statements_var_assign:

	; Prevent wedges from being executed within a program

!ifdef CONFIG_TAPE_WEDGE {
	cpx #$40
	+beq do_DIRECT_MODE_ONLY_error
}
!ifdef CONFIG_DOS_WEDGE {
	cpx #$5F
	+beq do_DIRECT_MODE_ONLY_error
}

	; Try variable assignment - execute as LET command

!ifndef HAS_OPCODES_65CE02 {
	jsr unconsume_character
} else {
	dew TXTPTR
}
	jmp assign_variable
