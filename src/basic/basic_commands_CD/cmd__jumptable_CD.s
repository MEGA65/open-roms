// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE

//
// Jumptable for BASIC commands with tokens prefixed by $CD
//


.const command_CD_list = List().add(

	cmd_slow,
	cmd_fast
)


#if !HAS_OPCODES_65C02


command_CD_jumptable_lo:

	put_jumptable_lo(command_CD_list)


command_CD_jumptable_hi:

	put_jumptable_hi(command_CD_list)


#else // HAS_OPCODES_65C02


__before_command_CD_jumptable:

.if (mod(*, $2) == 1) { brk }          // align code so that vector never crosses page boundary

command_CD_jumptable:

	put_jumptable(command_CD_list)

	// Make sure routine size is always the same - build system limitation

.if (__before_command_CD_jumptable == command_CD_jumptable) { brk }


#endif
