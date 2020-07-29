// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE


fetch_variable_arr:

	jsr find_array
	bcc !+

	// Array does not exist - we will have to create one with default parameters

	// XXX implement this

	jmp do_NOT_IMPLEMENTED_error
!:
	// Fetch the 'coordinates'

	ldx #$00                                     // counts number of dimensions

	// FALLTROUGH

fetch_variable_arr_fetch_coords_loop:

	inx

	// Check if the stack has reasonable space free

	jsr check_stack_space

	// Fetch the dimension and put it on the stack

	jsr fetch_uint16
	bcs_16 do_SYNTAX_error

	lda LINNUM+0
	pha
	lda LINNUM+1
	pha

	// Check if more dimensions are given

	jsr fetch_character_skip_spaces
	cmp #$2C                                     // ','
	beq fetch_variable_arr_fetch_coords_loop
	cmp #$29                                     // ')'
	bne_16 do_SYNTAX_error

	// FALLTROUGH

fetch_variable_arr_check_dimensions:

	// Check if the number of dimensions matches the stored ones

#if CONFIG_MEMORY_MODEL_60K
	
	// XXX
	// XXX
	// XXX

#elif CONFIG_MEMORY_MODEL_46K || CONFIG_MEMORY_MODEL_50K

	// XXX
	// XXX
	// XXX

#else // CONFIG_MEMORY_MODEL_38

	ldy #$04
	txa
	cmp (VARPNT), y

#endif

	bne_16 do_BAD_SUBSCRIPT_error

	// FALLTROUGH

fetch_variable_arr_calc_pos:

	// Move VARPNT po point to sizes in each dimension

	lda #$05
	jsr helper_VARPNT_up_A

	// Set previous dimension size as '1'

	// XXX implement this

	// FALLTROUGH

fetch_variable_arr_calc_pos_loop:

	// Fetch the coordinate from stack

	// XXX implement this

	// Compare current coordinate with current dimension size

	// XXX implement this

	// Multiply current coordinate with previous dimension

	// XXX implement this

	// Store current dimension, for the next iteration

	// XXX implement this

	// Check if there are more dimensions to handle

	dex
	bne fetch_variable_arr_calc_pos_loop

	// Increment VARPNT by the calculated offset and quit

	// XXX implement this

	jmp do_NOT_IMPLEMENTED_error
