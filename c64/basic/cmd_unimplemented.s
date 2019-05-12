	;; Default handler for all not-yet-implemented commands

cmd_for:
cmd_next:
cmd_data:
cmd_inputhash:
cmd_input:
cmd_dim:
cmd_read:
cmd_let:
cmd_if:
cmd_restore:
cmd_gosub:
cmd_return:
	
	;; $90-$9F
cmd_on:
cmd_wait:
cmd_save:
cmd_verify:
cmd_def:
cmd_poke:
cmd_printhash:
cmd_print:
cmd_cont:
cmd_cmd:
cmd_open:
	
	;; $A0-$AF
cmd_close:
cmd_get:
cmd_tab:
cmd_to:
cmd_fn:
cmd_spc:
cmd_then:
cmd_not:
cmd_step:
cmd_plus:
cmd_minus:
cmd_mult:
cmd_div:
cmd_exponent:
cmd_and:
	
	;; $B0-$BF
cmd_or:
cmd_greater:
cmd_equal:
cmd_less:
cmd_sgn:
cmd_int:
cmd_abs:
cmd_usr:
cmd_fre:
cmd_pos:
cmd_sqr:
cmd_rnd:
cmd_log:
cmd_exp:
cmd_cos:
cmd_sin:
	
	;; $C0-$CF
cmd_tan:
cmd_atn:
cmd_peek:
cmd_len:
cmd_str:
cmd_val:
cmd_asc:
cmd_chr:
cmd_left:
cmd_right:
cmd_mid:
cmd_go: 	
	;; Undefined tokens
cmd_unimplemented:

	
	
	jmp do_NOT_IMPLEMENTED_error
