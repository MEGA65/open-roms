;; #LAYOUT# CRT BASIC_0 #TAKE-FLOAT
;; #LAYOUT# CRT BASIC_1 #TAKE
;; #LAYOUT# *   *       #IGNORE

;
; Definitions for communication with cartridge segment BASIC_1 from BASIC_0
;


!ifdef SEGMENT_BASIC_0 {


	; Label definitions

	!addr JB1__INITMSG                  = $8000 + 3 * 0
	!addr JB1__LINKPRG                  = $8000 + 3 * 1
	!addr JB1__tokenise_line            = $8000 + 3 * 2
	!addr JB1__list_single_line         = $8000 + 3 * 3
	!addr JB1__print_packed_error       = $8000 + 3 * 4
	!addr JB1__print_packed_misc_str    = $8000 + 3 * 5
	!addr JB1__do_new                   = $8000 + 3 * 6
	!addr JB1__do_clr                   = $8000 + 3 * 7
	!addr JB1__do_restore               = $8000 + 3 * 8
	!addr JB1__cmd_mem_cont             = $8000 + 3 * 9
	!addr JB1__prepare_direct_execution = $8000 + 3 * 10
	!addr JB1__helper_ask_if_sure       = $8000 + 3 * 11

!ifdef CONFIG_DOS_WEDGE {
	!addr JB1__wedge_dos                = $8000 + 3 * 12      
}

} else {

	; Jump table (Open ROMs private!)

	jmp INITMSG
	jmp LINKPRG
	jmp tokenise_line
	jmp list_single_line
	jmp print_packed_error
	jmp print_packed_misc_str
	jmp do_new
	jmp do_clr
	jmp do_restore
	jmp cmd_mem_cont
	jmp prepare_direct_execution
	jmp helper_ask_if_sure

!ifdef CONFIG_DOS_WEDGE {
	jmp wedge_dos
}


}
