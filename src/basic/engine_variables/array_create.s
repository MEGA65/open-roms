// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE


array_create:

	// First retrieve array name

	jsr fetch_variable_name
	bcs_16 do_SYNTAX_error

	// Make sure the array does not exist

	jsr find_array
	bcc_16 do_REDIMD_ARRAY_error

	// Push variable name and FOUR6 on the stack - fetching dimensions might cause
	// the to be overwritten by the expression parser

	lda VARNAM+1
	pha
	lda VARNAM+0
	pha
	lda FOUR6
	pha

	// Check if the array dimension is given - if not, assume '10' was specified

	bit DIMFLG
	bmi array_create_fetch_dims

	lda #$0A
	pha
	lda #$00
	pha
	ldx #$01
	bne array_create_store_dims                  // branch always

array_create_fetch_dims:

	ldx #$00                                     // counts number of dimensions

	// FALLTROUGH

array_create_fetch_dims_loop:

	inx

	// Check if the stack has reasonable space free

	phx_trash_a
	jsr check_stack_space
	plx_trash_a

	// Fetch the dimension, increment it by 1, and put it on the stack;
	// confirmed with original ROM, that it also stores dimensions in the reverse order

	jsr fetch_uint16
	bcs_16 do_SYNTAX_error

#if !HAS_OPCODES_65CE02
	inc LINNUM+0
	bne !+
	inc LINNUM+1
!:
#else
	inw LINNUM
#endif

	beq_16 do_OUT_OF_MEMORY_error

	lda LINNUM+0
	pha
	lda LINNUM+1
	pha

	// Check if more dimensions are given

	jsr fetch_character_skip_spaces
	cmp #$2C                                     // ','
	beq array_create_fetch_dims_loop
	cmp #$29                                     // ')'
	bne_16 do_SYNTAX_error

	// FALLTROUGH

array_create_store_dims:

	// We got the dimensions, time to alocate memory. Arrays are not declared too often,
	// it will be easier if we perform the garbage collection now

	phx_trash_a
	jsr varstr_garbage_collect

	// __FAC1+1/+2 will be used to calculate number of elements

	ldy #$01
	sty __FAC1+1
	dey
	sty __FAC1+2

	// Check if there is enough free memory for the header

	pla                                          // .A - number of dimensions
	sta __FAC1+0
	jsr helper_array_create_checkmem
	lda __FAC1+0

	// Create the initial array structure (header) - format checked by creating arrays with original ROM

	// Bytes 0/1 - array name, but we can not fetch it easily now, so skip it for now
	// Bytes 2/3 - offset to the next array, skip it for now too
	// Byte  4   - number of dimensions
	// Bytes 5+  - max index in each dimension (big endian!), this will be set in a loop

	ldy #$04

#if CONFIG_MEMORY_MODEL_60K
	
	stx INDEX+2

	ldx #<STREND
	jsr poke_under_roms

	ldx INDEX+2

#else // CONFIG_MEMORY_MODEL_38K || CONFIG_MEMORY_MODEL_46K || CONFIG_MEMORY_MODEL_50K

	sta (STREND), y

#endif

	iny                                          // .Y - index to store dimension sizes
	tax                                          // .X - dimensions not stored yet

	// FALLTROUGH

array_create_store_loop:

#if CONFIG_MEMORY_MODEL_60K
	
	stx INDEX+2
	ldx #<STREND

	pla
	jsr poke_under_roms
	sta __FAC1+4
	iny
	pla
	jsr poke_under_roms
	sta __FAC1+3
	iny

	ldx INDEX+2

#else // CONFIG_MEMORY_MODEL_38K || CONFIG_MEMORY_MODEL_46K || CONFIG_MEMORY_MODEL_50K

	pla
	sta (STREND), y
	sta __FAC1+4
	iny
	pla
	sta (STREND), y
	sta __FAC1+3
	iny

#endif

	jsr helper_array_create_mul

	dex
	bne array_create_store_loop

	// Store .Y in a safe place - this is the header size

	sty __FAC1+5

	// FALLTROUGH

array_create_store_dims_done:

	// Restore FOUR6, calculate number of bytes needed for storage

	pla
	sta FOUR6                          // needed by variable fetch routine

	sta __FAC1+3
	stx __FAC1+4                       // .X is 0 at this point
	jsr helper_array_create_mul

	// Check if there is enough free memory

	jsr helper_array_create_checkmem

	// Retrieve and store array name

	ldy #$00

#if CONFIG_MEMORY_MODEL_60K
	
	ldx #<STREND

	pla
	jsr poke_under_roms
	iny
	pla
	jsr poke_under_roms

#else // CONFIG_MEMORY_MODEL_38K || CONFIG_MEMORY_MODEL_46K || CONFIG_MEMORY_MODEL_50K

	pla
	sta (STREND), y
	iny
	pla
	sta (STREND), y

#endif

	// Calculate and store offset to the next array

	lda #$05
	jsr helper_INDEX_up_A

	lda __FAC1+0
	asl
	jsr helper_INDEX_up_A

#if CONFIG_MEMORY_MODEL_60K

	// .X already contains STREND
	
	ldy #$02
	lda INDEX+0
	jsr poke_under_roms
	iny
	lda INDEX+1
	jsr poke_under_roms

#else // CONFIG_MEMORY_MODEL_38K || CONFIG_MEMORY_MODEL_46K || CONFIG_MEMORY_MODEL_50K

	ldy #$02
	lda INDEX+0
	sta (STREND), y
	iny
	lda INDEX+1
	sta (STREND), y

#endif

	// First increase STREND past the header

	clc
	lda __FAC1+5
	adc STREND+0
	sta STREND+0
	bcc !+
	inc STREND+1
!:
	// Clear the newly alocated area

	ldy #$00
#if CONFIG_MEMORY_MODEL_60K
	ldx #<STREND
#endif

	// FALLTROUGH

array_create_clear_loop:

	lda #$00

#if CONFIG_MEMORY_MODEL_60K
	jsr poke_under_roms
#else // CONFIG_MEMORY_MODEL_38K || CONFIG_MEMORY_MODEL_46K || CONFIG_MEMORY_MODEL_50K
	sta (STREND), y
#endif

#if !HAS_OPCODES_65CE02

	// Increment STREND+0/+1

	inc STREND+0
	bne !+
	inc STREND+1
!: 
	// Decrement __FAC1+1/+2

	sec
	lda __FAC1+1
	sbc #$01
	sta __FAC1+1
	bcs !+
	dec __FAC1+2
!:
	// Check if __FAC1+1/+2 is NULL

	ora __FAC1+2

#else

	inw STREND
	dew __FAC1+1

#endif

	bne array_create_clear_loop

	// The end

	rts
