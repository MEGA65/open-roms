// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE


fetch_variable:

	// Fetch variable name

	lda #$00
	sta VARNAM+1

	// Fetch the first character

	jsr fetch_character_skip_spaces
	jsr is_AZ
	bcs_16 do_SYNTAX_error

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

	jsr unconsume_character

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
	cmp VARPNT+0
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

	// Adjust VARPNT to point just after variable name and quit

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
	
	// First check if we have enough space for a new descriptor

	// XXX

	// If needed, move all the arrays up

	// XXX

	// Set pointer to new variable

	// XXX

	// Fill-in the new variable name, descriptor (it is enough to zero first 2 bytes of content)

	ldy #$00

#if CONFIG_MEMORY_MODEL_60K
	
	// XXX

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
