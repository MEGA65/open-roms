;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE


cmd_if:

!ifdef CONFIG_MB_M65 {

	jsr helper_if_mega65
	bcc cmd_if_true
}

	; Calculate expression

	jsr FRMEVL

	; Check the result - either string size or floating point 0 vs non-0

	lda FAC1_exponent
	+beq cmd_rem

	; FALLTROUGH

cmd_if_true:

	; Condition fulfilled - look for GOTO or THEN

	jsr fetch_character_skip_spaces
	cmp #$89                           ; 'GOTO'
	+beq cmd_goto

	cmp #$A7                           ; 'THEN'
	+bne do_SYNTAX_error

	pla
	pla

	jmp execute_statements
