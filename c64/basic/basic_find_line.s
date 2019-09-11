// Find the BASIC line with number basic_line_number


basic_find_line:
	// Get pointer to start of BASIC text
	lda basic_start_of_text_ptr+0
	sta basic_current_line_ptr+0
	lda basic_start_of_text_ptr+1
	sta basic_current_line_ptr+1

basic_find_line_loop:	
	// Then search for line number
	// Line number
	
	ldy #3

#if CONFIG_MEMORY_MODEL_60K
	ldx #<basic_current_line_ptr+0
	jsr peek_under_roms
#else // CONFIG_MEMORY_MODEL_38K
	lda (basic_current_line_ptr),y
#endif

	cmp basic_line_number+1
	beq !+
	bcs line_num_too_high
	bne not_this_line
!:
	
	dey

#if CONFIG_MEMORY_MODEL_60K
	jsr peek_under_roms
#else // CONFIG_MEMORY_MODEL_38K
	lda (basic_current_line_ptr),y
#endif

	cmp basic_line_number+0
	beq !+
	bcs line_num_too_high
	bne not_this_line
!:
	clc
	rts
not_this_line:
	// Not this line, so advance to next line
	jsr peek_line_pointer_null_check
	bcs more_lines_exist

	// no more lines exist, return failure
line_num_too_high:
	sec
	rts
more_lines_exist:	

	// XXX - Add program mangled check here to be triggered
	// if the link goes backwards.
	// Follow link to next line
	ldy #0

#if CONFIG_MEMORY_MODEL_60K
	ldx #<basic_current_line_ptr+0
	jsr peek_under_roms
#else // CONFIG_MEMORY_MODEL_38K
	lda (basic_current_line_ptr),y
#endif

	sta $0100
	iny

#if CONFIG_MEMORY_MODEL_60K
	jsr peek_under_roms
#else // CONFIG_MEMORY_MODEL_38K
	lda (basic_current_line_ptr),y
#endif

	sta basic_current_line_ptr+1
	lda $0100
	sta basic_current_line_ptr+0

	jmp basic_find_line_loop
