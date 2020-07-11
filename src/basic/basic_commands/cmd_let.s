// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE



cmd_let:

	// Fetch variable name, should be followed by assign operator

	jsr fetch_variable
	jsr injest_assign
	bcs_16 do_SYNTAX_error

	// Determine variable type and push it to the stack

	lda #$00
	clc
	bit VARNAM+0
	bpl !+
	adc #$01
!:
	bit VARNAM+1
	bpl !+
	adc #$80
!:
	pha

	// Push the VARPNT to the stack - it might get overridden

	lda VARPNT+0
	pha
	lda VARPNT+1
	pha

	// Evaluate the expression

	jsr FRMEVL

	// Restore VARPNT

	pla
	sta VARPNT+1
	pla
	sta VARPNT+0

	// Determine what to assign

	pla
	bmi cmd_let_assign_string
	beq cmd_let_assign_float

	// FALLTROUGH

	// XXX integer and float probably have much in common

cmd_let_assign_integer:

	lda VALTYP
	bmi_16 do_TYPE_MISMATCH_error

	// XXX finish the implementation

	jmp do_NOT_IMPLEMENTED_error

cmd_let_assign_float:

	lda VALTYP
	bmi_16 do_TYPE_MISMATCH_error

	// XXX finish the implementation

	jmp do_NOT_IMPLEMENTED_error

cmd_let_assign_string:

	// Check if value type matches
	
	lda VALTYP
	bpl_16 do_TYPE_MISMATCH_error

	// XXX finish the implementation

	jmp do_NOT_IMPLEMENTED_error
