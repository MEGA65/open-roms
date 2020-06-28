// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE


cmd_stop:

	jsr print_return

	ldx #IDX__EV2_1E // "BREAK"
	jsr print_packed_error

	// Are we in direct mode
	lda CURLIN+1
	cmp #$FF
	beq cmd_end

	// Not direct mode
	ldx #IDX__STR_IN
	jsr print_packed_misc_str

	lda CURLIN+1
	ldx CURLIN+0
	jsr print_integer

	// FALLTROUGH

cmd_end:

	jmp shell_main_loop
