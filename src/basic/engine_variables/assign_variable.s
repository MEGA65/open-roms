// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE


assign_variable:

	// Fetch variable name, should be followed by assign operator

	jsr fetch_variable_name

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

	// Check for special variables

	jsr is_var_TI_string
	beq_16 assign_variable_TI_string

	jsr is_var_TI
	beq_16 do_SYNTAX_error

	jsr is_var_ST
	beq_16 do_SYNTAX_error

	// Retrieve the variable address

	jsr fetch_variable_find_addr

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
	bmi assign_string
	beq assign_float

	// FALLTROUGH

	// XXX integer and float probably have much in common

assign_integer:

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

assign_float:

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

assign_string:

	// Check if value type matches
	
	lda VALTYP
	bpl_16 do_TYPE_MISMATCH_error

	// Copy the string descriptor to DSCPNT

	jsr helper_strdesccpy

	// First special case - check if the new string has size 0

	lda __FAC1+0
	bne assign_string_not_empty

	// Yes, it is empty - free the old one

	jsr varstr_free

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

assign_string_not_empty:

	// Check if the source and destination strings are the same

	lda DSCPNT+1
	cmp __FAC1+1
	bne assign_string_not_same
	iny
	lda DSCPNT+2
	cmp __FAC1+2
	bne assign_string_not_same

	// If we are here, than both source and destination strings are the same - nothing more to be done

	rts

assign_string_not_same:

	// Strings are not the same - check if the new one is located within the text area, between TXTTAB and VARTAB

	lda VARTAB+1
	cmp __FAC1+2
	bcc assign_string_not_text_area
	bne !+
	lda VARTAB+0
	cmp __FAC1+1
	bcc assign_string_not_text_area	
!:
	lda __FAC1+2
	cmp TXTTAB+1
	bcc assign_string_not_text_area
	bne !+
	lda __FAC1+1
	cmp TXTTAB+0
	bcc assign_string_not_text_area
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

assign_string_not_text_area:

	// Check if the old string belongs to the string area (is above FRETOP)

	jsr helper_cmp_fretop

#if HAS_SMALL_BASIC
	bcc assign_string_no_optimizations
#else
	bcc assign_string_try_takeover
#endif

	// FALLTROUGH

assign_string_try_reuse:

	// Check if we can reuse old string memory

	lda DSCPNT+0
	cmp __FAC1+0

#if HAS_SMALL_BASIC

	// If size of both string equals - simply reuse it

	beq_16 helper_strvarcpy

	// No special case optimization is possible - but first get rid of the old string

	jsr varstr_free

	// FALLTROUGH

#else

	// If size of both string equals - simply reuse it

	bne assign_string_try_takeover_free
	jmp helper_strvarcpy

#endif

assign_string_no_optimizations:

	// Allocate memory for the new string

	lda __FAC1+0
	ldy #$00

#if CONFIG_MEMORY_MODEL_60K

	ldx #<VARPNT
	jsr poke_under_roms

#else // CONFIG_MEMORY_MODEL_38K || CONFIG_MEMORY_MODEL_46K || CONFIG_MEMORY_MODEL_50K
	
	sta (VARPNT), y

#endif

	jsr varstr_alloc

	// Copy the string and quit

	jmp helper_strvarcpy


#if !HAS_SMALL_BASIC

assign_string_try_takeover_free:

	jsr varstr_free

	// FALLTROUGH

assign_string_try_takeover:

	// Check if the new string is a temporary one - if so, takeover the allocation

	ldx #$19

	// FALLTROUGH

assign_string_tmp_check_loop:

	cpx TEMPPT
	beq assign_string_no_optimizations // branch if this is not a temporary string

	lda $01, x
	cmp __FAC1+1
	bne assign_string_tmp_check_next

	lda $02, x
	cmp __FAC1+2
	bne assign_string_tmp_check_next

	lda $01, x
	beq assign_string_tmp_check_next

	// This is a temporary string - takeover the content

#if CONFIG_MEMORY_MODEL_60K

	ldy #$00
	phx_trash_a
	lda $00, x
	ldx #<VARPNT
	jsr poke_under_roms
	plx_trash_a

	iny
	phx_trash_a
	lda $01, x
	sta INDEX+0
	ldx #<VARPNT
	jsr poke_under_roms
	plx_trash_a
	
	iny
	phx_trash_a
	lda $02, x
	sta INDEX+1
	ldx #<VARPNT
	jsr poke_under_roms
	plx_trash_a

#else

	ldy #$00
	lda $00, x
	sta (VARPNT), y

	iny
	lda $01, x
	sta INDEX+0
	sta (VARPNT), y

	iny
	lda $02, x
	sta INDEX+1
	sta (VARPNT), y

#endif

	// Mark the temporary string as free

	lda #$00
	sta $00, x

	// Now we need to copy VARPNT to back-pointer

	lda __FAC1+0
	jsr helper_INDEX_up_A

#if CONFIG_MEMORY_MODEL_60K

	ldx #<INDEX

	ldy #$00
	lda VARPNT+0
	jsr poke_under_roms

	iny
	lda VARPNT+1
	jsr poke_under_roms

#else

	ldy #$00
	lda VARPNT+0
	sta (INDEX), y

	iny
	lda VARPNT+1
	sta (INDEX), y

#endif

	rts

assign_string_tmp_check_next:

	inx
	inx
	inx
	bne assign_string_tmp_check_loop           // branch always

#endif
