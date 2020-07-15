// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE

//
// Carry set = failure, not recognized variable name
//


fetch_variable:

	// Fetch variable name

	lda #$00
	sta VARNAM+1

	// Fetch the first character

	jsr fetch_character_skip_spaces
	jsr is_AZ
	bcc !+

#if !HAS_OPCODES_65CE02
	jsr unconsume_character
#else
	dew TXTPTR
#endif

	sec
	rts
!:
	sta VARNAM+0

	// Fetch the (optional) second character

	jsr fetch_character
	jsr is_09_AZ
	bcs fetch_variable_check_type

	sta VARNAM+1

	// Fetch the remaining variable characters - ignore them
!:
	jsr fetch_character
	jsr is_09_AZ
	bcc !-

	// FALLTROUGH

fetch_variable_check_type:

	// Encode variable type within name, as documented in:
	// - https://sites.google.com/site/h2obsession/CBM/basic/variable-format

	cmp #$24                           // '$'
	beq fetch_variable_type_string
	cmp #$25                           // '%'
	beq fetch_variable_type_integer

	// FALLTORUGH

fetch_variable_type_float:

#if !HAS_OPCODES_65CE02
	jsr unconsume_character
#else
	dew TXTPTR
#endif

#if HAS_OPCODES_65C02
	bra fetch_variable_find_addr
#else
	jmp fetch_variable_find_addr
#endif

fetch_variable_type_integer:

	lda VARNAM+0
	ora #$80
	sta VARNAM+0

	// FALLTROUGH

fetch_variable_type_string:

	lda VARNAM+1
	ora #$80
	sta VARNAM+1
	
	// FALLTROUGH

fetch_variable_find_addr:

	// Now try to find variable address between VARTAB and ARYTAB, see
	// - https://www.c64-wiki.com/wiki/Memory_(BASIC)

	lda VARTAB+0
	sta VARPNT+0
	lda VARTAB+1
	sta VARPNT+1

	// FALLTROUGH

fetch_variable_find_addr_loop:

	// Check if end of search loop

	lda VARPNT+1
	cmp ARYTAB+1
	bne !+
	lda VARPNT+0
	cmp ARYTAB+0
	beq fetch_variable_alocate
!:
	// Compare current variable name with searched one
	// XXX consider creating optimized version for 46K/50K memory models

	ldy #$00

#if CONFIG_MEMORY_MODEL_60K
	ldx #<VARPNT
	jsr peek_under_roms
#elif CONFIG_MEMORY_MODEL_46K || CONFIG_MEMORY_MODEL_50K
	jsr peek_under_roms_via_VARPNT
#else // CONFIG_MEMORY_MODEL_38K
	lda (VARPNT),y
#endif

	cmp VARNAM+0
	bne fetch_variable_find_addr_next

	iny

#if CONFIG_MEMORY_MODEL_60K
	jsr peek_under_roms
#elif CONFIG_MEMORY_MODEL_46K || CONFIG_MEMORY_MODEL_50K
	jsr peek_under_roms_via_VARPNT
#else // CONFIG_MEMORY_MODEL_38K
	lda (VARPNT),y
#endif

	cmp VARNAM+1
	bne fetch_variable_find_addr_next

	// FALLTROUGH

fetch_variable_adjust_VARPNT:

	// Adjust VARPNT to point just after variable name (XXX is it needed?) and quit

#if !HAS_OPCODES_65CE02

	clc
	lda VARPNT+0
	adc #$02
	sta VARPNT+0
	bcc !+
	inc VARPNT+1
!:
#else // HAS_OPCODES_65CE02

	inw VARPNT
	inw VARPNT

#endif

	clc
	rts

fetch_variable_find_addr_next:

	// Increase VARPNT by 7 - constant value, each variable uses 7 bytes, see:
	// - https://sites.google.com/site/h2obsession/CBM/basic/variable-format

	clc
	lda VARPNT+0
	adc #$07
	sta VARPNT+0
	bcc fetch_variable_find_addr_loop
	inc VARPNT+1
	bne fetch_variable_find_addr_loop  // branch always

fetch_variable_alocate:
	
	// First check if we have enough space for a new descriptor (if FRETOP - STREND >= 7)

	sec
	lda FRETOP+0
	sbc STREND+0
	pha
	lda FRETOP+1
	sbc STREND+1
	bne !+                             // branch if high byte of result > 0

	pla
	cmp #$07
	bcs fetch_variable_alocate_space_OK

	jmp do_OUT_OF_MEMORY_error
!:
	pla

	// FALLTROUGH

fetch_variable_alocate_space_OK:

	// If needed, move all the arrays up

#if CONFIG_MEMORY_MODEL_60K
	
	// XXX
	// XXX: implement this for arrays
	// XXX

#elif CONFIG_MEMORY_MODEL_46K || CONFIG_MEMORY_MODEL_50K
	// XXX consider optimized version without multiple JSRs

	// XXX
	// XXX: implement this for arrays
	// XXX

#else // CONFIG_MEMORY_MODEL_38K

	// XXX
	// XXX: implement this for arrays
	// XXX

#endif

	// Adjust ARYTAB and STREND

	clc
	lda STREND+0
	adc #$07
	sta STREND+0
	bcc !+
	inc STREND+1
!:

	clc
	lda ARYTAB+0
	adc #$07
	sta ARYTAB+0
	bcc !+
	inc ARYTAB+1
!:
	// VARPNT already points to the start of the variable descriptor

	// Fill-in the new variable name, descriptor (it is enough to zero first 2 bytes of content)

	ldy #$00

#if CONFIG_MEMORY_MODEL_60K

	ldx #<VARNAM
	lda VARNAM+0
	jsr poke_under_roms
	iny
	lda VARNAM+1
	jsr poke_under_roms
	iny
	lda #$00
	jsr poke_under_roms
	iny
	jsr poke_under_roms

#else // CONFIG_MEMORY_MODEL_38K || CONFIG_MEMORY_MODEL_46K || CONFIG_MEMORY_MODEL_50K
	
	lda VARNAM+0
	sta (VARPNT),y
	iny
	lda VARNAM+1
	sta (VARPNT),y
	iny
	lda #$00
	sta (VARPNT),y
	iny
	sta (VARPNT),y

#endif

	// Adjust variable pointer and quit

#if HAS_OPCODES_65C02
	bra fetch_variable_adjust_VARPNT
#else
	jmp fetch_variable_adjust_VARPNT
#endif
