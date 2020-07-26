// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE


array_create:

	// First retrieve array name

	jsr fetch_variable_name
	bcs_16 do_SYNTAX_error

	// XXX check if the array already exists

	// Push variable name and FOUR6 on the stack - fetching dimensions might cause
	// the to be overwritten by the expression parser

	lda VARNAM+0
	pha
	lda VARNAM+1
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

	// XXX check if stack has reasonable space free

	// Fetch the dimension, put it on the stack - confirmed with orioginal ROM,
	// that it also stores dimensions in the reverse order

	jsr fetch_uint16
	bcs_16 do_SYNTAX_error

	// XXX we probably need to increment LINNUM first

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

	// __FAC1+0/+1 will be used to calculate number of elements

	ldy #$01
	sty __FAC1+0
	dey
	sty __FAC1+1

	// Create the initial array structure (format checked by creating arrays with original ROM)

	// Bytes 0/1 - array name, but we can not fetch it easily now, so skip it for now
	// Bytes 2/3 - offset to the next array, skip it for now too
	// Byte  4   - number of dimensions
	// Bytes 5+  - max index in each dimension (big endian!), this will be set in a loop

	ldy #$04
	pla

#if CONFIG_MEMORY_MODEL_60K
	
	// XXX
	// XXX: implement this
	// XXX

#else // CONFIG_MEMORY_MODEL_38K || CONFIG_MEMORY_MODEL_46K || CONFIG_MEMORY_MODEL_50K

	sta (STREND), y

#endif

	iny                                          // .Y - index to store dimension sizes
	tax                                          // .X - dimensions not sotred yet

	// FALLTROUGH

array_create_store_loop:

#if CONFIG_MEMORY_MODEL_60K
	
	// XXX
	// XXX: implement this
	// XXX

#else // CONFIG_MEMORY_MODEL_38K || CONFIG_MEMORY_MODEL_46K || CONFIG_MEMORY_MODEL_50K

	pla
	sta (STREND), y
	sta __FAC1+3
	iny
	pla
	sta (STREND), y
	sta __FAC1+2
	iny

#endif

	jsr helper_array_create_mul

	dex
	bne array_create_store_loop

	// FALLTROUGH

array_create_store_dims_done:

	// Restore FOUR6, calculate number of bytes needed for storage

	pha
	sta FOUR6 // XXX do we need to store this value in FOUR6?
	sta __FAC1+2
	stx __FAC1+3                       // .X is 0 at this point

	jsr helper_array_create_mul

	// XXX check if we have enough memory

	// XXX retrieve and store array name

	// XXX calculate and store offset to the next array

	// XXX clear area

	// XXX adjust STREND

	// XXX adjust offset of the previous array

	jmp do_NOT_IMPLEMENTED_error

