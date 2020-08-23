// #LAYOUT# M65 BASIC_0 #TAKE-FLOAT
// #LAYOUT# M65 BASIC_1 #TAKE
// #LAYOUT# *   *       #IGNORE

//
// Definitions for communication with Mega65 segment BASIC_1 from BASIC_0
//


#if SEGMENT_BASIC_0


	// Label definitions

	.label VB1__INITMSG                  = $4000 + 2 * 0
	.label VB1__LINKPRG                  = $4000 + 2 * 1
	.label VB1__tokenise_line            = $4000 + 2 * 2
	.label VB1__list_single_line         = $4000 + 2 * 3
	.label VB1__print_packed_error       = $4000 + 2 * 4
	.label VB1__print_packed_misc_str    = $4000 + 2 * 5
	.label VB1__do_new                   = $4000 + 2 * 6
	.label VB1__do_clr                   = $4000 + 2 * 7
	.label VB1__do_restore               = $4000 + 2 * 8
	.label VB1__cmd_mem_cont             = $4000 + 2 * 9
	.label VB1__cmd_sysinfo              = $4000 + 2 * 10
	.label VB1__prepare_direct_execution = $4000 + 2 * 11
	.label VB1__helper_ask_if_sure       = $4000 + 2 * 12

#if CONFIG_DOS_WEDGE
	.label VB1__wedge_dos                = $4000 + 2 * 12      
#endif

#else

	// Vector table (Open ROMs private!)

	.word INITMSG
	.word LINKPRG
	.word tokenise_line
	.word list_single_line
	.word print_packed_error
	.word print_packed_misc_str
	.word do_new
	.word do_clr
	.word do_restore
	.word cmd_mem_cont
	.word cmd_sysinfo
	.word prepare_direct_execution
	.word helper_ask_if_sure

#if CONFIG_DOS_WEDGE
	.word wedge_dos
#endif


#endif
