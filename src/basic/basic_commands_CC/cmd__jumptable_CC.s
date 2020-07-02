// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE

//
// Jumptable for BASIC commands with tokens prefixed by $CC
//


.const command_CC_list = List().add(

	cmd_merge,

	cmd_bload,
	cmd_bsave,
	cmd_bverify,

	cmd_old,
	cmd_cold
)


#if !HAS_OPCODES_65C02


command_CC_jumptable_lo:

	put_jumptable_lo(command_CC_list)


command_CC_jumptable_hi:

	put_jumptable_hi(command_CC_list)


#else // HAS_OPCODES_65C02


__before_command_CC_jumptable:

.if (mod(*, $2) == 1) { brk }          // align code so that vector never crosses page boundary

command_CC_jumptable:

	put_jumptable(command_CC_list)

	// Make sure routine size is always the same - build system limitation

.if (__before_command_CC_jumptable == command_CC_jumptable) { brk }


#endif
