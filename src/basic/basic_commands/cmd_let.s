// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE



cmd_let:

	// Fetch variable name, should be followed by assign operator

	jsr fetch_variable

#if HAS_OPCODES_65CE02

	bcs_16 do_SYNTAX_error
	jsr injest_assign
	bcs_16 do_SYNTAX_error

#else

	bcs !+
	jsr injest_assign
	bcc !++
!:
	jmp do_SYNTAX_error
!:

#endif

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
	
	ldx #<VARPNT

	ldy #$00
	jsr peek_under_roms
	sta DSCPNT+0
	iny
	jsr peek_under_roms
	sta DSCPNT+1
	iny
	jsr peek_under_roms
	sta DSCPNT+2

#elif CONFIG_MEMORY_MODEL_46K || CONFIG_MEMORY_MODEL_50K

	jsr helper_let_strdesccpy

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

	lda __FAC1+0
	bne cmd_let_assign_string_not_empty

	// Yes, it is empty - check if the old one is, free it if necessary

	lda DSCPNT+0
	bne !+
	jsr varstr_free
!:
	// Set the new variable as empty string

	ldy #$00
	lda #$00

#if CONFIG_MEMORY_MODEL_60K
	ldx #<VARPNT
	jsr poke_under_roms
#else // CONFIG_MEMORY_MODEL_38K || CONFIG_MEMORY_MODEL_46K || CONFIG_MEMORY_MODEL_50K
	sta (VARPNT), y
#endif

	rts

cmd_let_assign_string_not_empty:

	// Check if the source and destination strings are the same

	lda DSCPNT+1
	cmp __FAC1+1
	bne cmd_let_assign_string_not_same
	iny
	lda DSCPNT+2
	cmp __FAC1+2
	bne cmd_let_assign_string_not_same

	// If we are here, than both source and destination strings are the same - nothing more to be done

	rts

cmd_let_assign_string_not_same:

	// Strings are not the same - check if the new one is located within the text area, between TXTTAB and VARTAB

	lda VARTAB+1
	cmp __FAC1+2
	bcc cmd_let_assign_string_not_text_area
	bne !+
	lda VARTAB+0
	cmp __FAC1+1
	bcc cmd_let_assign_string_not_text_area	
!:
	lda __FAC1+2
	cmp TXTTAB+1
	bcc cmd_let_assign_string_not_text_area
	bne !+
	lda __FAC1+1
	cmp TXTTAB+0
	bcc cmd_let_assign_string_not_text_area
!:
	// String is located within text area - great, just copy the descriptor

#if CONFIG_MEMORY_MODEL_60K
	
	// .X already contains #<VARPNT

	ldy #$00
	lda __FAC1+0
	jsr poke_under_roms
	iny
	lda __FAC1+1
	jsr poke_under_roms
	iny
	lda __FAC1+2
	jsr poke_under_roms

#else // CONFIG_MEMORY_MODEL_38K || CONFIG_MEMORY_MODEL_46K || CONFIG_MEMORY_MODEL_50K

	ldy #$00
	lda __FAC1+0
	sta (VARPNT), y
	iny
	lda __FAC1+1
	sta (VARPNT), y
	iny
	lda __FAC1+2
	sta (VARPNT), y

#endif

	rts

cmd_let_assign_string_not_text_area:

	// Check if size of both strings equals and the old on is above FRETOP

	// XXX

	// Check if new one is at least 3 bytes shorter and the old one is above FRETOP

	// XXX

	// Check if the new string is a temporary one - if so, reuse already done alocation

	// XXX

	// No special case optimization is possible
	// Free the memory belonging to the old string

	// XXX
	// jsr varstr_free


	// And allocate memory for the new string

	lda __FAC1+0
	ldy #$00

#if CONFIG_MEMORY_MODEL_60K

	ldx #<VARPNT
	jsr poke_under_roms

#else // CONFIG_MEMORY_MODEL_38K || CONFIG_MEMORY_MODEL_46K || CONFIG_MEMORY_MODEL_50K
	
	sta (VARPNT), y

#endif

	jsr varstr_alloc

	// Copy the string

#if CONFIG_MEMORY_MODEL_60K
	
	ldx #<VARPNT

	ldy #$02
	jsr peek_under_roms
	sta DSCPNT+2
	dey
	jsr peek_under_roms
	sta DSCPNT+1
	dey

	// .Y is now 0 - copy the content
!:

	ldx #<__FAC1+1
	jsr peek_under_roms
	ldx #<DSCPNT+1
	jsr poke_under_roms
	iny
	cpy __FAC1+0
	bne !-

#elif CONFIG_MEMORY_MODEL_46K || CONFIG_MEMORY_MODEL_50K
	
	jsr helper_let_strvarcpy

#else // CONFIG_MEMORY_MODEL_38K

	// Retrieve pointer to destination

	ldy #$02
	lda (VARPNT), y
	sta DSCPNT+2
	dey
	lda (VARPNT), y
	sta DSCPNT+1
	dey

	// .Y is now 0 - copy the content
!:
	lda (__FAC1+1),y
	sta (DSCPNT+1),y
	iny
	cpy __FAC1+0
	bne !-

#endif

	rts
