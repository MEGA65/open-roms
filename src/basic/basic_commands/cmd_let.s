// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE



cmd_let:

	// Fetch variable name, should be followed by assign operator

	jsr fetch_variable
	bcs_16 do_SYNTAX_error
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

#if CONFIG_MEMORY_MODEL_60K
	
	// XXX
	// XXX: implement this
	// XXX

#elif CONFIG_MEMORY_MODEL_46K || CONFIG_MEMORY_MODEL_50K
	// XXX consider optimized version without multiple JSRs

	// XXX
	// XXX: implement this
	// XXX

#else // CONFIG_MEMORY_MODEL_38K

	// XXX
	// XXX: implement this
	// XXX

#endif

	jmp do_NOT_IMPLEMENTED_error

cmd_let_assign_float:

	lda VALTYP
	bmi_16 do_TYPE_MISMATCH_error

#if CONFIG_MEMORY_MODEL_60K
	
	// XXX
	// XXX: implement this
	// XXX

#elif CONFIG_MEMORY_MODEL_46K || CONFIG_MEMORY_MODEL_50K
	// XXX consider optimized version without multiple JSRs

	// XXX
	// XXX: implement this
	// XXX

#else // CONFIG_MEMORY_MODEL_38K

	// XXX
	// XXX: implement this
	// XXX

#endif

	jmp do_NOT_IMPLEMENTED_error

cmd_let_assign_string:

	// Check if value type matches
	
	lda VALTYP
	bpl_16 do_TYPE_MISMATCH_error

	// Copy the string descriptor to DSCPNT

#if CONFIG_MEMORY_MODEL_60K
	
	// XXX
	// XXX: implement this
	// XXX

#elif CONFIG_MEMORY_MODEL_46K || CONFIG_MEMORY_MODEL_50K
	// XXX consider optimized version without multiple JSRs

	// XXX
	// XXX: implement this
	// XXX

#else // CONFIG_MEMORY_MODEL_38K

	ldy #$00
	lda (VARPNT), y
	sta DSCPNT+0
	iny
	lda (VARPNT), y
	sta DSCPNT+1
	iny
	lda (VARPNT), y
	sta DSCPNT+2

#endif

	// First special case - check if the new string has size 0

	lda DSCPNT+0
	bne cmd_let_assign_string_not_empty

	// XXX free old string data

	// Set the new variable as size 0

#if CONFIG_MEMORY_MODEL_60K
	
	// XXX
	// XXX: implement this
	// XXX

#else // CONFIG_MEMORY_MODEL_38K || CONFIG_MEMORY_MODEL_46K || CONFIG_MEMORY_MODEL_50K


#endif

	rts

cmd_let_assign_string_not_empty:

	// Check if the source and destination strings are the same (VARPNT should now point just after variable name)

	lda VARPNT+0
	cmp __FAC1+1
	bne !+
	iny
	lda VARPNT+1
	cmp __FAC1+2
	bne !+

	// If we are here, than both source and destination strings are the same - nothing more to be done

	rts
!:
	// Strings are not the same - check if the new one is located within a text area, between TXTTAB and VARTAB

	// XXX

	// Check if size of both equals and the old on is above FRETOP

	// XXX

	// Check if new one is at least 3 bytes shorter and the old one is above FRETOP

	// XXX

	// Free the memory of the old string, it is not possible to reuse it

	// XXX

	// Check if the new string is a temporary one - if so, reuse already done alocation

	// XXX

	// No special case optimization is possible - alocate new memory area and copy the string

	// XXX

#if CONFIG_MEMORY_MODEL_60K
	
	// XXX
	// XXX: implement this
	// XXX

#elif CONFIG_MEMORY_MODEL_46K || CONFIG_MEMORY_MODEL_50K
	// XXX consider optimized version without multiple JSRs

	// XXX
	// XXX: implement this
	// XXX

#else // CONFIG_MEMORY_MODEL_38K

	// XXX
	// XXX: implement this
	// XXX

#endif

	jmp do_NOT_IMPLEMENTED_error
