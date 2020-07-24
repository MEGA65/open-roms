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

	// Push 0 to mark end of the dimensions

	lda #$00
	pha

	// Now check if the array dimension is given - if not, assume '10' was specified

	bit DIMFLG
	bmi array_create_fetch_dims

	lda #$0A
	pha
	bne array_create_store_dims                  // branch always

array_create_fetch_dims:

	// XXX check if stack has reasonable space free

	// Fetch the dimension, put it on the stack - confirmed with orioginal ROM,
	// that it also stores dimensions in the reverse order

	jsr fetch_uint8
	bcs_16 do_SYNTAX_error
	pha

	// Check if more dimensions are given

	jsr fetch_character_skip_spaces
	cmp #$2C                                     // ','
	beq array_create_fetch_dims
	cmp #$29                                     // ')'
	bne_16 do_SYNTAX_error

	// FALLTROUGH

array_create_store_dims:

	// We got the dimensions, time to alocate memory. Arrays are not declared too often,
	// it will be easier if we perform the garbage collection now

	jsr varstr_garbage_collect

	// Create the initial array structure

	// Bytes 0/1 - array name, but we can not fetch it easily now, so skip it
	// Bytes 2/3 - offset to the next array - our will be the last one, so 0 - but we will set it later
	// Byte  4   - number of dimensions, determine it
	// Bytes 5+  - size in each dimension

	// INDEX+2/+3 will be used to calculate number of 'records'

	ldy #$01
	sty INDEX+3
	dey
	sty INDEX+4

	ldy #$05
!:
	pla
	beq array_create_store_num_dims

	// XXX implement this


array_create_store_num_dims:

	// .Y contains number of dimensions + 5

	// XXX rework code below







	jsr do_NOT_IMPLEMENTED_error
