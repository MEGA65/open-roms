// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE

//
// Jumptable for BASIC commands with tokens prefixed by $01
//


.const command_01_list = List().add(

	cmd_slow,
	cmd_fast,
	cmd_old,

	// NOTE! These commands are temporarily placed here, they should be a part of list 02!

	cmd_merge,

	cmd_bload,
	cmd_bsave,
	cmd_bverify,

	cmd_clear,
	varstr_garbage_collect            // cmd_dispose
)


#if !HAS_OPCODES_65C02


command_01_jumptable_lo:

	put_jumptable_lo(command_01_list)


command_01_jumptable_hi:

	put_jumptable_hi(command_01_list)


#else // HAS_OPCODES_65C02


__before_command_01_jumptable:

.if (mod(*, $2) == 1) { brk }          // align code so that vector never crosses page boundary

command_01_jumptable:

	put_jumptable(command_01_list)

	// Make sure routine size is always the same - build system limitation

.if (__before_command_01_jumptable == command_01_jumptable) { brk }


#endif
