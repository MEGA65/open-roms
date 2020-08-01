// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE

//
// Helper routine for fetching array coordinates
//
// If this was last coordinate, set .Y to $FF, otherwise to $00
//

helper_fetch_arr_coord:

	// Check if the stack has reasonable space free

	jsr check_stack_space

	// Fetch the dimension

	jsr fetch_uint16
	bcs !+

	jsr fetch_character_skip_spaces
	cmp #$2C                                     // ','
	beq helper_fetch_arr_more
	cmp #$29                                     // ')'
	beq helper_fetch_arr_last

	// FALLTROUGH
!:
	jmp do_SYNTAX_error

helper_fetch_arr_more:

	ldy #$00
	rts

helper_fetch_arr_last:

	ldy #$FF
	rts
