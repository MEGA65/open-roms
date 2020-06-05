// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE

//
// Jumptable for all known BASIC commands and functions
//


#if !HAS_OPCODES_65C02


command_jumptable_lo:

	// $80 - $8F
	.byte <(cmd_end-1)
	.byte <(cmd_for-1)
	.byte <(cmd_next-1)
	.byte <(cmd_data-1)
	.byte <(cmd_inputhash-1)
	.byte <(cmd_input-1)
	.byte <(cmd_dim-1)
	.byte <(cmd_read-1)
	.byte <(cmd_let-1)
	.byte <(cmd_goto-1)
	.byte <(cmd_run-1)
	.byte <(cmd_if-1)
	.byte <(cmd_restore-1)
	.byte <(cmd_gosub-1)
	.byte <(cmd_return-1)
	.byte <(cmd_rem-1)

	// $90-$9F
	.byte <(cmd_stop-1)
	.byte <(cmd_on-1)
	.byte <(cmd_wait-1)
	.byte <(cmd_load-1)
	.byte <(cmd_save-1)
	.byte <(cmd_verify-1)
	.byte <(cmd_def-1)
	.byte <(cmd_poke-1)
	.byte <(cmd_printhash-1)
	.byte <(cmd_print-1)
	.byte <(cmd_cont-1)
	.byte <(cmd_list-1)
	.byte <(cmd_clr-1)
	.byte <(cmd_cmd-1)
	.byte <(cmd_sys-1)
	.byte <(cmd_open-1)

	// $A0-$AF
	.byte <(cmd_close-1)
	.byte <(cmd_get-1)
	.byte <(cmd_new-1)
	.byte <(cmd_tab-1)
	.byte <(cmd_to-1)
	.byte <(cmd_fn-1)
	.byte <(cmd_spc-1)
	.byte <(cmd_then-1)
	.byte <(cmd_not-1)
	.byte <(cmd_step-1)
	.byte <(cmd_plus-1)
	.byte <(cmd_minus-1)
	.byte <(cmd_mult-1)
	.byte <(cmd_div-1)
	.byte <(cmd_exponent-1)
	.byte <(cmd_and-1)

	// $B0-$BF
	.byte <(cmd_or-1)
	.byte <(cmd_greater-1)
	.byte <(cmd_equal-1)
	.byte <(cmd_less-1)
	.byte <(cmd_sgn-1)
	.byte <(cmd_int-1)
	.byte <(cmd_abs-1)
	.byte <(cmd_usr-1)
	.byte <(cmd_fre-1)
	.byte <(cmd_pos-1)
	.byte <(cmd_sqr-1)
	.byte <(cmd_rnd-1)
	.byte <(cmd_log-1)
	.byte <(cmd_exp-1)
	.byte <(cmd_cos-1)
	.byte <(cmd_sin-1)

	// $C0-$CF
	.byte <(cmd_tan-1)
	.byte <(cmd_atn-1)
	.byte <(cmd_peek-1)
	.byte <(cmd_len-1)
	.byte <(cmd_str-1)
	.byte <(cmd_val-1)
	.byte <(cmd_asc-1)
	.byte <(cmd_chr-1)
	.byte <(cmd_left-1)
	.byte <(cmd_right-1)
	.byte <(cmd_mid-1)
	.byte <(cmd_go-1)
	.byte <(cmd_unimplemented-1)
	.byte <(cmd_unimplemented-1)
	.byte <(cmd_unimplemented-1)
	.byte <(cmd_unimplemented-1)

	// $D0-$DF
	.byte <(cmd_unimplemented-1)
	.byte <(cmd_unimplemented-1)
	.byte <(cmd_unimplemented-1)
	.byte <(cmd_unimplemented-1)
	.byte <(cmd_unimplemented-1)
	.byte <(cmd_unimplemented-1)
	.byte <(cmd_unimplemented-1)
	.byte <(cmd_unimplemented-1)
	.byte <(cmd_unimplemented-1)
	.byte <(cmd_unimplemented-1)
	.byte <(cmd_unimplemented-1)
	.byte <(cmd_unimplemented-1)
	.byte <(cmd_unimplemented-1)
	.byte <(cmd_unimplemented-1)
	.byte <(cmd_unimplemented-1)
	.byte <(cmd_unimplemented-1)

	// $E0-$EF
	.byte <(cmd_unimplemented-1)
	.byte <(cmd_unimplemented-1)
	.byte <(cmd_unimplemented-1)
	.byte <(cmd_unimplemented-1)
	.byte <(cmd_unimplemented-1)
	.byte <(cmd_unimplemented-1)
	.byte <(cmd_unimplemented-1)
	.byte <(cmd_unimplemented-1)
	.byte <(cmd_unimplemented-1)
	.byte <(cmd_unimplemented-1)
	.byte <(cmd_unimplemented-1)
	.byte <(cmd_unimplemented-1)
	.byte <(cmd_unimplemented-1)
	.byte <(cmd_unimplemented-1)
	.byte <(cmd_unimplemented-1)
	.byte <(cmd_unimplemented-1)

	// $F0-$FF
	.byte <(cmd_unimplemented-1)
	.byte <(cmd_unimplemented-1)
	.byte <(cmd_unimplemented-1)
	.byte <(cmd_unimplemented-1)
	.byte <(cmd_unimplemented-1)
	.byte <(cmd_unimplemented-1)
	.byte <(cmd_unimplemented-1)
	.byte <(cmd_unimplemented-1)
	.byte <(cmd_unimplemented-1)
	.byte <(cmd_unimplemented-1)
	.byte <(cmd_unimplemented-1)
	.byte <(cmd_unimplemented-1)
	.byte <(cmd_unimplemented-1)
	.byte <(cmd_unimplemented-1)
	.byte <(cmd_unimplemented-1)
	.byte <(cmd_unimplemented-1)


command_jumptable_hi:

	// $80 - $8F
	.byte >(cmd_end-1)
	.byte >(cmd_for-1)
	.byte >(cmd_next-1)
	.byte >(cmd_data-1)
	.byte >(cmd_inputhash-1)
	.byte >(cmd_input-1)
	.byte >(cmd_dim-1)
	.byte >(cmd_read-1)
	.byte >(cmd_let-1)
	.byte >(cmd_goto-1)
	.byte >(cmd_run-1)
	.byte >(cmd_if-1)
	.byte >(cmd_restore-1)
	.byte >(cmd_gosub-1)
	.byte >(cmd_return-1)
	.byte >(cmd_rem-1)

	// $90-$9F
	.byte >(cmd_stop-1)
	.byte >(cmd_on-1)
	.byte >(cmd_wait-1)
	.byte >(cmd_load-1)
	.byte >(cmd_save-1)
	.byte >(cmd_verify-1)
	.byte >(cmd_def-1)
	.byte >(cmd_poke-1)
	.byte >(cmd_printhash-1)
	.byte >(cmd_print-1)
	.byte >(cmd_cont-1)
	.byte >(cmd_list-1)
	.byte >(cmd_clr-1)
	.byte >(cmd_cmd-1)
	.byte >(cmd_sys-1)
	.byte >(cmd_open-1)

	// $A0-$AF
	.byte >(cmd_close-1)
	.byte >(cmd_get-1)
	.byte >(cmd_new-1)
	.byte >(cmd_tab-1)
	.byte >(cmd_to-1)
	.byte >(cmd_fn-1)
	.byte >(cmd_spc-1)
	.byte >(cmd_then-1)
	.byte >(cmd_not-1)
	.byte >(cmd_step-1)
	.byte >(cmd_plus-1)
	.byte >(cmd_minus-1)
	.byte >(cmd_mult-1)
	.byte >(cmd_div-1)
	.byte >(cmd_exponent-1)
	.byte >(cmd_and-1)

	// $B0-$BF
	.byte >(cmd_or-1)
	.byte >(cmd_greater-1)
	.byte >(cmd_equal-1)
	.byte >(cmd_less-1)
	.byte >(cmd_sgn-1)
	.byte >(cmd_int-1)
	.byte >(cmd_abs-1)
	.byte >(cmd_usr-1)
	.byte >(cmd_fre-1)
	.byte >(cmd_pos-1)
	.byte >(cmd_sqr-1)
	.byte >(cmd_rnd-1)
	.byte >(cmd_log-1)
	.byte >(cmd_exp-1)
	.byte >(cmd_cos-1)
	.byte >(cmd_sin-1)

	// $C0-$CF
	.byte >(cmd_tan-1)
	.byte >(cmd_atn-1)
	.byte >(cmd_peek-1)
	.byte >(cmd_len-1)
	.byte >(cmd_str-1)
	.byte >(cmd_val-1)
	.byte >(cmd_asc-1)
	.byte >(cmd_chr-1)
	.byte >(cmd_left-1)
	.byte >(cmd_right-1)
	.byte >(cmd_mid-1)
	.byte >(cmd_go-1)
	.byte >(cmd_unimplemented-1)
	.byte >(cmd_unimplemented-1)
	.byte >(cmd_unimplemented-1)
	.byte >(cmd_unimplemented-1)

	// $D0-$DF
	.byte >(cmd_unimplemented-1)
	.byte >(cmd_unimplemented-1)
	.byte >(cmd_unimplemented-1)
	.byte >(cmd_unimplemented-1)
	.byte >(cmd_unimplemented-1)
	.byte >(cmd_unimplemented-1)
	.byte >(cmd_unimplemented-1)
	.byte >(cmd_unimplemented-1)
	.byte >(cmd_unimplemented-1)
	.byte >(cmd_unimplemented-1)
	.byte >(cmd_unimplemented-1)
	.byte >(cmd_unimplemented-1)
	.byte >(cmd_unimplemented-1)
	.byte >(cmd_unimplemented-1)
	.byte >(cmd_unimplemented-1)
	.byte >(cmd_unimplemented-1)

	// $E0-$EF
	.byte >(cmd_unimplemented-1)
	.byte >(cmd_unimplemented-1)
	.byte >(cmd_unimplemented-1)
	.byte >(cmd_unimplemented-1)
	.byte >(cmd_unimplemented-1)
	.byte >(cmd_unimplemented-1)
	.byte >(cmd_unimplemented-1)
	.byte >(cmd_unimplemented-1)
	.byte >(cmd_unimplemented-1)
	.byte >(cmd_unimplemented-1)
	.byte >(cmd_unimplemented-1)
	.byte >(cmd_unimplemented-1)
	.byte >(cmd_unimplemented-1)
	.byte >(cmd_unimplemented-1)
	.byte >(cmd_unimplemented-1)
	.byte >(cmd_unimplemented-1)

	// $F0-$FF
	.byte >(cmd_unimplemented-1)
	.byte >(cmd_unimplemented-1)
	.byte >(cmd_unimplemented-1)
	.byte >(cmd_unimplemented-1)
	.byte >(cmd_unimplemented-1)
	.byte >(cmd_unimplemented-1)
	.byte >(cmd_unimplemented-1)
	.byte >(cmd_unimplemented-1)
	.byte >(cmd_unimplemented-1)
	.byte >(cmd_unimplemented-1)
	.byte >(cmd_unimplemented-1)
	.byte >(cmd_unimplemented-1)
	.byte >(cmd_unimplemented-1)
	.byte >(cmd_unimplemented-1)
	.byte >(cmd_unimplemented-1)
	.byte >(cmd_unimplemented-1)


#else // HAS_OPCODES_65C02

__before_command_jumptable:

.if (mod(*, $2) == 1) { brk }          // align code so that vector never crosses page boundary

command_jumptable:

	// $80 - $8F
	.word cmd_end
	.word cmd_for
	.word cmd_next
	.word cmd_data
	.word cmd_inputhash
	.word cmd_input
	.word cmd_dim
	.word cmd_read
	.word cmd_let
	.word cmd_goto
	.word cmd_run
	.word cmd_if
	.word cmd_restore
	.word cmd_gosub
	.word cmd_return
	.word cmd_rem

	// $90-$9F
	.word cmd_stop
	.word cmd_on
	.word cmd_wait
	.word cmd_load
	.word cmd_save
	.word cmd_verify
	.word cmd_def
	.word cmd_poke
	.word cmd_printhash
	.word cmd_print
	.word cmd_cont
	.word cmd_list
	.word cmd_clr
	.word cmd_cmd
	.word cmd_sys
	.word cmd_open

	// $A0-$AF
	.word cmd_close
	.word cmd_get
	.word cmd_new
	.word cmd_tab
	.word cmd_to
	.word cmd_fn
	.word cmd_spc
	.word cmd_then
	.word cmd_not
	.word cmd_step
	.word cmd_plus
	.word cmd_minus
	.word cmd_mult
	.word cmd_div
	.word cmd_exponent
	.word cmd_and

	// $B0-$BF
	.word cmd_or
	.word cmd_greater
	.word cmd_equal
	.word cmd_less
	.word cmd_sgn
	.word cmd_int
	.word cmd_abs
	.word cmd_usr
	.word cmd_fre
	.word cmd_pos
	.word cmd_sqr
	.word cmd_rnd
	.word cmd_log
	.word cmd_exp
	.word cmd_cos
	.word cmd_sin

	// $C0-$CF
	.word cmd_tan
	.word cmd_atn
	.word cmd_peek
	.word cmd_len
	.word cmd_str
	.word cmd_val
	.word cmd_asc
	.word cmd_chr
	.word cmd_left
	.word cmd_right
	.word cmd_mid
	.word cmd_go
	.word cmd_unimplemented
	.word cmd_unimplemented
	.word cmd_unimplemented
	.word cmd_unimplemented

	// $D0-$DF
	.word cmd_unimplemented
	.word cmd_unimplemented
	.word cmd_unimplemented
	.word cmd_unimplemented
	.word cmd_unimplemented
	.word cmd_unimplemented
	.word cmd_unimplemented
	.word cmd_unimplemented
	.word cmd_unimplemented
	.word cmd_unimplemented
	.word cmd_unimplemented
	.word cmd_unimplemented
	.word cmd_unimplemented
	.word cmd_unimplemented
	.word cmd_unimplemented
	.word cmd_unimplemented

	// $E0-$EF
	.word cmd_unimplemented
	.word cmd_unimplemented
	.word cmd_unimplemented
	.word cmd_unimplemented
	.word cmd_unimplemented
	.word cmd_unimplemented
	.word cmd_unimplemented
	.word cmd_unimplemented
	.word cmd_unimplemented
	.word cmd_unimplemented
	.word cmd_unimplemented
	.word cmd_unimplemented
	.word cmd_unimplemented
	.word cmd_unimplemented
	.word cmd_unimplemented
	.word cmd_unimplemented

	// $F0-$FF
	.word cmd_unimplemented
	.word cmd_unimplemented
	.word cmd_unimplemented
	.word cmd_unimplemented
	.word cmd_unimplemented
	.word cmd_unimplemented
	.word cmd_unimplemented
	.word cmd_unimplemented
	.word cmd_unimplemented
	.word cmd_unimplemented
	.word cmd_unimplemented
	.word cmd_unimplemented
	.word cmd_unimplemented
	.word cmd_unimplemented
	.word cmd_unimplemented
	.word cmd_unimplemented

	// Make sure routine size is always the same - build system limitation

.if (__before_command_jumptable == command_jumptable) { brk }

#endif
