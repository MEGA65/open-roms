// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE


// XXX does not fully work

fetch_variable_TI_string:

	// Alocate memory for 6-byte temporary string, copy the string descriptor

	lda #$06
	jsr tmpstr_alloc
	jsr helper_strdesccpy

	// Fetch the time in a safe way, store it in temporary area

	jsr JRDTIM

	sty INDEX+2
	stx INDEX+1
	sta INDEX+0

	// Now calculate the digits, starting from the most important one

#if CONFIG_MEMORY_MODEL_60K
	ldx #<DSCPNT+1
#endif

	ldy #$00

	// FALLTROUGH

fetch_variable_TI_string_loop:

	// Set the initial digit value ('0')

	lda #$30
	sta INDEX+3

	// Compare the counter with value from table
!:
	lda INDEX+2
	cmp table_TI_hi, y
	bcc fetch_variable_TI_string_got_digit
	bne fetch_variable_TI_string_inc_digit
	lda INDEX+1
	cmp table_TI_mid, y
	bcc fetch_variable_TI_string_got_digit
	bne fetch_variable_TI_string_inc_digit
	lda INDEX+0
	cmp table_TI_lo, y
	bcc fetch_variable_TI_string_got_digit

fetch_variable_TI_string_inc_digit:

	// Increment digit and subtract the table value from the counter

	inc INDEX+3

	sec
	lda INDEX+0
	sbc table_TI_lo, y
	sta INDEX+0
	lda INDEX+1
	sbc table_TI_mid, y
	sta INDEX+1
	lda INDEX+2
	sbc table_TI_hi, y
	sta INDEX+2

	bcs !-                   // branch always

fetch_variable_TI_string_got_digit:

	// Copy digit to the string

	lda INDEX+3

#if CONFIG_MEMORY_MODEL_60K
	jsr poke_under_roms
#else // CONFIG_MEMORY_MODEL_38K || CONFIG_MEMORY_MODEL_50K || CONFIG_MEMORY_MODEL_60K
	sta (DSCPNT+1), y
#endif

	// Next iteration

	iny
	cpy #$06
	bne fetch_variable_TI_string_loop

	// Return success

	clc
	rts
