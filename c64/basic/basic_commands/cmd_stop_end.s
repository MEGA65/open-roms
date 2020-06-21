// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE


cmd_stop:
	ldx #IDX__EV2_1E // "BREAK"
	jsr print_packed_error

	// Are we in direct mode
	lda CURLIN+1
	cmp #$FF
	beq !+

	// Not direct mode
	ldx #IDX__STR_IN
	jsr print_packed_misc_str

	lda CURLIN+1
	ldx CURLIN+0
	jsr print_integer

!:
	jsr print_return

cmd_end:
	jmp basic_main_loop
