// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE

//
// Jumptable for BASIC commands with tokens prefixed by $02
//

#if !HAS_SMALL_BASIC

.const command_02_list = List().add(

	// NOTE! These commands are temporarily placed in list 01!

	// cmd_merge,

	// cmd_bload,
	// cmd_bsave,
	// cmd_bverify,

	// cmd_clear,
	// varstr_garbage_collect,            // cmd_dispose

	cmd_cold,
	cmd_mem,
	cmd_sysinfo
)


#if !HAS_OPCODES_65C02


command_02_jumptable_lo:

	put_jumptable_lo(command_02_list)


command_02_jumptable_hi:

	put_jumptable_hi(command_02_list)


#else // HAS_OPCODES_65C02

command_02_jumptable:

	// Note: 65C02 has the page boundary vector bug fixed!
	put_jumptable(command_02_list)

#endif

#endif
