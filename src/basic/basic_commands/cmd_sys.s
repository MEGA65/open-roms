// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE


#if ROM_LAYOUT_M65

cmd_nsys:
	
	// NSYS requires an argument

	jsr is_end_of_statement
	bcs_16 do_SYNTAX_error
	bra cmd_sys_nsys_common

#endif

cmd_sys:
	
	// SYS requires an argument

	jsr is_end_of_statement
	bcs_16 do_SYNTAX_error

#if ROM_LAYOUT_M65

	// Make sure we are in C64 compatibility mode

	jsr M65_MODEGET
	bcs cmd_sys_nsys_common
	sec
	jsr M65_MODESET                    // set legacy C64 compatibility mode

	// FALLTROUGH

cmd_sys_nsys_common:

#endif

	//
	// XXX Temporary ugly hack to support 'SYS PI*656'
	//

	ldy #$00

cmd_sys_hack_loop:
	lda (TXTPTR), y
	cmp cmd_sys_hack_str, y
	bne cmd_sys_hack_not_needed
	lda (TXTPTR), y
	beq cmd_sys_hack_apply
	iny
	bne cmd_sys_hack_loop // branch always

cmd_sys_hack_apply:

	lda #<2060
	sta LINNUM+0
	lda #>2060
	sta LINNUM+1
	bne cmd_sys_setup_call // always jumps

cmd_sys_hack_not_needed:

	//
	// XXX End of hack
	//

	lda #IDX__EV2_0B // 'SYNTAX ERROR'
	jsr fetch_uint16
	bcs_16 do_SYNTAX_error

cmd_sys_setup_call:
	lda #$4C // JMP opcode
	sta USRPOK
	lda LINNUM+0
	sta USRADD+0
	lda LINNUM+1
	sta USRADD+1
	
	// Setup the register values
	lda SPREG
	pha
	ldy SYREG
	ldx SXREG
	lda SAREG
	plp

	// Call the routine.
	jmp USRPOK

	//
	// XXX Temporary ugly hack to support 'SYS PI*656'
	//

cmd_sys_hack_str:
	.byte $FF, $AC, $36, $35, $36, $00
