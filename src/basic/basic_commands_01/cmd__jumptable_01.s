// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE

//
// Jumptable for BASIC commands with tokens prefixed by $01
//


.const command_01_list = List().add(

#if CONFIG_MB_MEGA_65
	M65_SLOW,
	M65_FAST,
#else
	cmd_slow,
	cmd_fast,
#endif

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

command_01_jumptable:

	// Note: 65C02 has the page boundary vector bug fixed!
	put_jumptable(command_01_list)

#endif
