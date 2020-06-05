// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE

//
// Default handler for all not-yet-implemented commands
//
// Note: NOPs are here just to make debugging easier!
//

cmd_for:
	nop
cmd_next:
	nop
cmd_data:
	nop
cmd_inputhash:
	nop
cmd_input:
	nop
cmd_dim:
	nop
cmd_read:
	nop
cmd_let:
	nop
cmd_if:
	nop
cmd_restore:
	nop
cmd_gosub:
	nop
cmd_return:
	nop
	
	// $90-$9F

cmd_on:
	nop
cmd_wait:
	nop
cmd_def:
	nop
cmd_poke:
	nop
cmd_printhash:
	nop
cmd_print:
	nop
cmd_cont:
	nop
cmd_cmd:
	nop
cmd_open:
	nop

	// $A0-$AF

cmd_close:
	nop
cmd_get:
	nop
cmd_tab:
	nop
cmd_to:
	nop
cmd_fn:
	nop
cmd_spc:
	nop
cmd_then:
	nop
cmd_not:
	nop
cmd_step:
	nop
cmd_plus:
	nop
cmd_minus:
	nop
cmd_mult:
	nop
cmd_div:
	nop
cmd_exponent:
	nop
cmd_and:
	nop

	// $B0-$BF

cmd_or:
	nop
cmd_greater:
	nop
cmd_equal:
	nop
cmd_less:
	nop
cmd_sgn:
	nop
cmd_int:
	nop
cmd_abs:
	nop
cmd_usr:
	nop
cmd_fre:
	nop
cmd_pos:
	nop
cmd_sqr:
	nop
cmd_rnd:
	nop
cmd_log:
	nop
cmd_exp:
	nop
cmd_cos:
	nop
cmd_sin:
	nop

	// $C0-$CF

cmd_tan:
	nop
cmd_atn:
	nop
cmd_peek:
	nop
cmd_len:
	nop
cmd_str:
	nop
cmd_val:
	nop
cmd_asc:
	nop
cmd_chr:
	nop
cmd_left:
	nop
cmd_right:
	nop
cmd_mid:
	nop
cmd_go:
 	nop

	// Undefined tokens

cmd_unimplemented:

	jmp do_NOT_IMPLEMENTED_error
