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

	lda FOUR6
	pha                                          // FOUR6 might get overridden, but we'll need it

	ldx #$00                                     // counts number of dimensions

	// FALLTROUGH

fetch_variable_arr_fetch_coords_loop:

	inx

	// Fetch the coordinate and put it on the stack

	jsr helper_fetch_arr_coord

	lda LINNUM+1
	pha
	lda LINNUM+0
	pha

	// If more coordinates given - next iteration

	cpy #$00
	beq fetch_variable_arr_fetch_coords_loop

	// Store number of dimensions, will be needed later

	stx __FAC1+0

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

	// Set the initial offset as '0'

	lda #$00
	sta __FAC1+1
	sta __FAC1+2

	// FALLTROUGH

fetch_variable_arr_calc_pos_loop:

	// Fetch the current dimension

	dex
	txa
	asl
	tay

#if CONFIG_MEMORY_MODEL_60K
	
	ldx #<VARPNT

	jsr peek_under_roms
	sta __FAC1+4
	iny
	jsr peek_under_roms
	sta __FAC1+3
	iny

#elif CONFIG_MEMORY_MODEL_46K || CONFIG_MEMORY_MODEL_50K

	jsr helper_array_fetch_dimension

#else // CONFIG_MEMORY_MODEL_38

	lda (VARPNT), y
	sta __FAC1+4
	iny
	lda (VARPNT), y
	sta __FAC1+3
	iny

#endif

	// Multiply offset by current dimension

	jsr helper_array_create_mul

	// Fetch the coordinate from stack; also add it to offset

	clc
	pla
	sta INDEX+0
	adc __FAC1+1
	sta __FAC1+1
	pla
	sta INDEX+1
	adc __FAC1+2
	sta __FAC1+2

	// Compare current coordinate with current dimension size

	// XXX
	// XXX implement this
	// XXX

	// Check if there are more dimensions to handle

	cpx #$00
	bne fetch_variable_arr_calc_pos_loop

	// FALLTROUGH

fetch_variable_arr_calc_pos_loop_done:

	// Retrieve FOUR6, use it to calculate final offset

	pla

	sta FOUR6                          // XXX is it needed?
	sta __FAC1+3
	stx __FAC1+4                       // .X is 0 at this moment

	jsr helper_array_create_mul

	// Increment VARPNT by number of dimensions * 2, to point start of data

	lda __FAC1+0
	asl
	jsr helper_VARPNT_up_A

	// Increment VARPNT by the calculated offset and quit

	clc
	lda __FAC1+1
	adc VARPNT+0
	sta VARPNT+0
	lda __FAC1+2
	adc VARPNT+1
	sta VARPNT+1

	rts
