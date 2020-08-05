// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE

// Carry set = unable to find array


find_array:

	 // Initialize VARPNT with the start of array area

	 lda ARYTAB+0
	 sta VARPNT+0
	 lda ARYTAB+1
	 sta VARPNT+1

	 // FALLTROUGH

find_array_loop:

	// Check if end of arrays

	lda VARPNT+1
	cmp STREND+1
	bne !+
	lda VARPNT+0
	cmp STREND+0
	bne !+

	// End of arrays

	sec
	rts
!:
	jsr helper_cmp_varnam

#if CONFIG_MEMORY_MODEL_46K || CONFIG_MEMORY_MODEL_50K
	bne_16 find_array_next
#else // CONFIG_MEMORY_MODEL_38K || CONFIG_MEMORY_MODEL_60K
	bne find_array_next
#endif

	// Array found

	clc
	rts


#if CONFIG_MEMORY_MODEL_38K || CONFIG_MEMORY_MODEL_60K

find_array_next:

	// Fetch offset to the next array

	ldy #$03

#if CONFIG_MEMORY_MODEL_60K
	
	ldx #<VARPNT

	jsr peek_under_roms
	pha
	dey
	jsr peek_under_roms

#else // CONFIG_MEMORY_MODEL_38K

	lda (VARPNT),y
	pha
	dey
	lda	(VARPNT),y

#endif

	// Adjust VARPNT to point to the next array

	clc
	adc VARPNT+0
	sta VARPNT+0

	pla
	adc VARPNT+1
	sta VARPNT+1	

	// Next iteration

	bcc find_array_loop                // branch always

#endif
