// Advance basic_current_line_ptr by following the
// link to the next line

basic_find_next_line:

	ldy #0

#if CONFIG_MEMORY_MODEL_60K
	ldx #<basic_current_line_ptr+0
	jsr peek_under_roms
#else // CONFIG_MEMORY_MODEL_38K
	lda (basic_current_line_ptr),y
#endif

	pha
	iny

#if CONFIG_MEMORY_MODEL_60K
	jsr peek_under_roms
#else // CONFIG_MEMORY_MODEL_38K
	lda (basic_current_line_ptr),y
#endif

	sta basic_current_line_ptr+1
	pla
	sta basic_current_line_ptr+0
	rts
