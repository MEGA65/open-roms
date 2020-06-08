// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE

//
// Jumptable for all known BASIC commands
//


.const command_list = List().add(

	// $80 - $8F

	cmd_end,
	cmd_for,
	cmd_next,
	cmd_data,
	cmd_inputhash,
	cmd_input,
	cmd_dim,
	cmd_read,
	cmd_let,
	cmd_goto,
	cmd_run,
	cmd_if,
	cmd_restore,
	cmd_gosub,
	cmd_return,
	cmd_rem,

	// $90-$9F

	cmd_stop,
	cmd_on,
	cmd_wait,
	cmd_load,
	cmd_save,
	cmd_verify,
	cmd_def,
	cmd_poke,
	cmd_printhash,
	cmd_print,
	cmd_cont,
	cmd_list,
	cmd_clr,
	cmd_cmd,
	cmd_sys,
	cmd_open,

	// $A0-$A6

	cmd_close,
	cmd_get,
	cmd_new,
	cmd_tab,                           // XXX this token probably does not belong here
	do_SYNTAX_error,                   // 'TO' is not a standalone command
	do_SYNTAX_error,                   // 'FN' is not a standalone command
	cmd_spc,                           // XXX this token probably does not belong here
	
	// 'THEN' ($A7) and 'STEP' ($A9) are not standalone commands
	// 'NOT' ($A8) is an operator, not a command

	// $CB, but remapped to $A7

	cmd_go
)


#if !HAS_OPCODES_65C02


command_jumptable_lo:

	put_jumptable_lo(command_list)


command_jumptable_hi:

	put_jumptable_hi(command_list)


#else // HAS_OPCODES_65C02


__before_command_jumptable:

.if (mod(*, $2) == 1) { brk }          // align code so that vector never crosses page boundary

command_jumptable:

	put_jumptable(command_list)

	// Make sure routine size is always the same - build system limitation

.if (__before_command_jumptable == command_jumptable) { brk }


#endif
