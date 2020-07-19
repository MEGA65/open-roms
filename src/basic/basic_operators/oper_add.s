// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE


oper_add:

	// This operator can be used either with two strings, or with two floats
	// First check whether arguments match and then choose the variant

	pla
	cmp VALTYP
	bne_16 do_TYPE_MISMATCH_error

	lda VALTYP
	bmi oper_add_strings

	// FALLTROUGH

oper_add_floats:

	// XXX implement this

	jmp do_NOT_IMPLEMENTED_error

oper_add_strings:

	// Retrieve string address

	pla
	sta __FAC2+2
	pla
	sta __FAC2+1

	// Pull string length

	pla
	sta __FAC2+0

	// If string 2 is empty, release it and quit

	beq oper_add_strings_end

	// If string 1 is empty, just copy the metadata

	lda __FAC1+0
	bne !+

	jsr tmpstr_free_FAC1

	lda __FAC2+0
	sta __FAC1+0
	lda __FAC2+1
	sta __FAC1+1
	lda __FAC2+2
	sta __FAC1+2

	jmp FRMEVL_continue
!:
	// Allocate memory for the concatenated string

	clc
	adc __FAC2+0
	bcs_16 do_STRING_TOO_LONG_error

	jsr tmpstr_alloc

	// Copy the temporary string pointer to INDEX

	ldy #$01
	lda (VARPNT), y
	sta INDEX+0
	iny
	lda (VARPNT), y
	sta INDEX+1

	// Perform the concatenation

#if CONFIG_MEMORY_MODEL_60K
	
	// Copy data from the first string

	ldy #$00
!:
	ldx #<(__FAC2+1)
	jsr peek_under_roms
	ldx #<INDEX
	jsr poke_under_roms
	iny
	cpy __FAC2+0
	bne !-

	// Increase INDEX pointer by the size of the 1st string

	tya
	jsr helper_INDEX_up_A

	// Copy data from the second string

	ldy #$00
!:
	ldx #<(__FAC1+1)
	jsr peek_under_roms
	ldx #<INDEX
	jsr poke_under_roms
	iny
	cpy __FAC1+0
	bne !-

#elif CONFIG_MEMORY_MODEL_46K || CONFIG_MEMORY_MODEL_50K

	jsr helper_strconcat

#else // CONFIG_MEMORY_MODEL_38K

	// Copy data from the first string

	ldy #$00
!:
	lda (__FAC2+1),y
	sta (INDEX),y
	iny
	cpy __FAC2+0
	bne !-

	// Increase INDEX pointer by the size of the 1st string

	tya
	jsr helper_INDEX_up_A

	// Copy data from the second string

	ldy #$00
!:
	lda (__FAC1+1),y
	sta (INDEX),y
	iny
	cpy __FAC1+0
	bne !-

#endif

	// Free old FAC1 string - if it was temporary

	jsr tmpstr_free_FAC1

	// Copy the descriptor to __FAC1

	ldy #$02
!:
	lda (VARPNT), y
	sta __FAC1, y
	dey
	bpl !-

	// FALLTROUGH

oper_add_strings_end:

	jsr tmpstr_free_FAC2
	jmp FRMEVL_continue
