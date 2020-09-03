// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE


cmd_if:

	// Calculate expression

	jsr FRMEVL

	// Check the result - either string size or floating point 0 vs non-0

	lda FAC1_exponent
	beq_16 cmd_rem

	// Condition fulfilled - look for GOTO or THEN

	jsr fetch_character_skip_spaces
	cmp #$89                           // 'GOTO'
	beq_16 cmd_goto

	cmp #$A7                           // 'THEN'
	bne_16 do_SYNTAX_error

	pla
	pla

	jmp execute_statements
