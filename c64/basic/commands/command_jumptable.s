// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE

//
// Jumptable for all known BASIC commands and functions
//


command_jumptable:

	// $80 - $8F
	.word cmd_end-1
	.word cmd_for-1
	.word cmd_next-1
	.word cmd_data-1
	.word cmd_inputhash-1
	.word cmd_input-1
	.word cmd_dim-1
	.word cmd_read-1
	.word cmd_let-1
	.word cmd_goto-1
	.word cmd_run-1
	.word cmd_if-1
	.word cmd_restore-1
	.word cmd_gosub-1
	.word cmd_return-1
	.word cmd_rem-1

	// $90-$9F
	.word cmd_stop-1
	.word cmd_on-1
	.word cmd_wait-1
	.word cmd_load-1
	.word cmd_save-1
	.word cmd_verify-1
	.word cmd_def-1
	.word cmd_poke-1
	.word cmd_printhash-1
	.word cmd_print-1
	.word cmd_cont-1
	.word cmd_list-1
	.word cmd_clr-1
	.word cmd_cmd-1
	.word cmd_sys-1
	.word cmd_open-1

	// $A0-$AF
	.word cmd_close-1
	.word cmd_get-1
	.word cmd_new-1
	.word cmd_tab-1
	.word cmd_to-1
	.word cmd_fn-1
	.word cmd_spc-1
	.word cmd_then-1
	.word cmd_not-1
	.word cmd_step-1
	.word cmd_plus-1
	.word cmd_minus-1
	.word cmd_mult-1
	.word cmd_div-1
	.word cmd_exponent-1
	.word cmd_and-1

	// $B0-$BF
	.word cmd_or-1
	.word cmd_greater-1
	.word cmd_equal-1
	.word cmd_less-1
	.word cmd_sgn-1
	.word cmd_int-1
	.word cmd_abs-1
	.word cmd_usr-1
	.word cmd_fre-1
	.word cmd_pos-1
	.word cmd_sqr-1
	.word cmd_rnd-1
	.word cmd_log-1
	.word cmd_exp-1
	.word cmd_cos-1
	.word cmd_sin-1

	// $C0-$CF
	.word cmd_tan-1
	.word cmd_atn-1
	.word cmd_peek-1
	.word cmd_len-1
	.word cmd_str-1
	.word cmd_val-1
	.word cmd_asc-1
	.word cmd_chr-1
	.word cmd_left-1
	.word cmd_right-1
	.word cmd_mid-1
	.word cmd_go-1 	
	// Undefined tokens
	.word cmd_unimplemented-1
	.word cmd_unimplemented-1
	.word cmd_unimplemented-1
	.word cmd_unimplemented-1

	// $D0-$DF
	.word cmd_unimplemented-1
	.word cmd_unimplemented-1
	.word cmd_unimplemented-1
	.word cmd_unimplemented-1
	.word cmd_unimplemented-1
	.word cmd_unimplemented-1
	.word cmd_unimplemented-1
	.word cmd_unimplemented-1
	.word cmd_unimplemented-1
	.word cmd_unimplemented-1
	.word cmd_unimplemented-1
	.word cmd_unimplemented-1
	.word cmd_unimplemented-1
	.word cmd_unimplemented-1
	.word cmd_unimplemented-1
	.word cmd_unimplemented-1

	// $E0-$EF
	.word cmd_unimplemented-1
	.word cmd_unimplemented-1
	.word cmd_unimplemented-1
	.word cmd_unimplemented-1
	.word cmd_unimplemented-1
	.word cmd_unimplemented-1
	.word cmd_unimplemented-1
	.word cmd_unimplemented-1
	.word cmd_unimplemented-1
	.word cmd_unimplemented-1
	.word cmd_unimplemented-1
	.word cmd_unimplemented-1
	.word cmd_unimplemented-1
	.word cmd_unimplemented-1
	.word cmd_unimplemented-1
	.word cmd_unimplemented-1

	// $F0-$FF
	.word cmd_unimplemented-1
	.word cmd_unimplemented-1
	.word cmd_unimplemented-1
	.word cmd_unimplemented-1
	.word cmd_unimplemented-1
	.word cmd_unimplemented-1
	.word cmd_unimplemented-1
	.word cmd_unimplemented-1
	.word cmd_unimplemented-1
	.word cmd_unimplemented-1
	.word cmd_unimplemented-1
	.word cmd_unimplemented-1
	.word cmd_unimplemented-1
	.word cmd_unimplemented-1
	.word cmd_unimplemented-1
	.word cmd_unimplemented-1
