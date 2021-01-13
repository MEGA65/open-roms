;; #LAYOUT# M65 BASIC_0 #TAKE-FLOAT
;; #LAYOUT# M65 BASIC_1 #TAKE
;; #LAYOUT# *   *       #IGNORE

;
; Definitions for communication with MEGA65 segment BASIC_1 from BASIC_0
;


!ifdef SEGMENT_BASIC_0 {


	; Label definitions

	!addr VB1__INITMSG                  = $4000 + 2 * 0
	!addr VB1__INITMSG_autoswitch       = $4000 + 2 * 1
	!addr VB1__LINKPRG                  = $4000 + 2 * 2
	!addr VB1__tokenise_line            = $4000 + 2 * 3
	!addr VB1__list_single_line         = $4000 + 2 * 4
	!addr VB1__print_packed_error       = $4000 + 2 * 5
	!addr VB1__print_packed_misc_str    = $4000 + 2 * 6
	!addr VB1__do_new                   = $4000 + 2 * 7
	!addr VB1__do_clr                   = $4000 + 2 * 8
	!addr VB1__do_restore               = $4000 + 2 * 9
	!addr VB1__cmd_mem_cont             = $4000 + 2 * 10
	!addr VB1__cmd_sysinfo              = $4000 + 2 * 11
	!addr VB1__prepare_direct_execution = $4000 + 2 * 12
	!addr VB1__helper_ask_if_sure       = $4000 + 2 * 13
	!addr VB1__helper_eggshell          = $4000 + 2 * 14
	!addr VB1__wedge_dos                = $4000 + 2 * 15
	!addr VB1__wedge_dos_monitor        = $4000 + 2 * 16

} else {

	; Vector table (Open ROMs private!)

	!word INITMSG
	!word INITMSG_autoswitch
	!word LINKPRG
	!word tokenise_line
	!word list_single_line
	!word print_packed_error
	!word print_packed_misc_str
	!word do_new
	!word do_clr
	!word do_restore
	!word cmd_mem_cont
	!word cmd_sysinfo
	!word prepare_direct_execution
	!word helper_ask_if_sure
	!word helper_eggshell
	!word wedge_dos
	!word wedge_dos_monitor

}
