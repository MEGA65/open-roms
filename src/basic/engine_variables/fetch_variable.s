// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE

//
// Carry set = failure, not recognized variable name
//


fetch_variable:

	// Start by fetching variable name

	jsr fetch_variable_name
	bcc !+
	rts
!:
	// Handle special variables - TI$, TI, ST

	jsr is_var_TI_string
	beq_16 fetch_variable_TI_string

	jsr is_var_TI
	beq_16 fetch_variable_TI

	jsr is_var_ST
	beq_16 fetch_variable_ST

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

#if CONFIG_MEMORY_MODEL_46K || CONFIG_MEMORY_MODEL_50K
	jsr helper_cmp_varnam
#else

	ldy #$00

#if CONFIG_MEMORY_MODEL_60K
	ldx #<VARPNT
	jsr peek_under_roms
#else // CONFIG_MEMORY_MODEL_38K
	lda (VARPNT),y
#endif

	cmp VARNAM+0
	bne fetch_variable_find_addr_next

	iny

#if CONFIG_MEMORY_MODEL_60K
	jsr peek_under_roms
#else // CONFIG_MEMORY_MODEL_38K
	lda (VARPNT),y
#endif

	cmp VARNAM+1

#endif

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

	ldx #<VARPNT
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

	jmp_8 fetch_variable_adjust_VARPNT
