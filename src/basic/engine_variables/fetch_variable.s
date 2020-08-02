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
	// If this is array, redirect to appropriate routine

	bit DIMFLG
	bmi_16 fetch_variable_arr

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

	jsr helper_cmp_varnam
	bne fetch_variable_find_addr_next

	// FALLTROUGH

fetch_variable_adjust_VARPNT:

	// Adjust VARPNT to point just after variable name and quit

#if !HAS_OPCODES_65CE02

	lda #$02
	jsr helper_VARPNT_up_A

#else // HAS_OPCODES_65CE02

	inw VARPNT
	inw VARPNT

#endif

	clc
	rts

fetch_variable_find_addr_next:

	// Increase VARPNT by 7 - constant value, each variable uses 7 bytes, see:
	// - https://sites.google.com/site/h2obsession/CBM/basic/variable-format

	lda #$07
	jsr helper_VARPNT_up_A

	jmp_8 fetch_variable_find_addr_loop

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

	// If arrays exist, we need to move them upwards

	sec
	lda STREND+0
	sta memmove__src+0
	sbc ARYTAB+0
	sta memmove__size+0	
	lda STREND+1
	sta memmove__src+1
	sbc ARYTAB+1
	sta memmove__size+1

	ora memmove__size+0
	beq fetch_variable_alocate_adjust_vars

	// Indeed, there are arrays - adjust size, calculate the destination and perform copytin

	inc memmove__size+0
	bne !+
	inc memmove__size+1

	clc
	lda memmove__src+0
	adc #$07
	sta memmove__dst+0
	lda memmove__src+1
	adc #$00
	sta memmove__dst+1

	jsr shift_mem_up

	// FALLTROUGH

fetch_variable_alocate_adjust_vars:

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

	// We need to recreate the back-pointers to string arrays

	jsr helper_array_refresh_bptrs

	// Fill-in the new variable name and descriptor (it is enough to zero first 2 bytes of content)

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

	jmp fetch_variable_adjust_VARPNT
