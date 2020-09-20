;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

;
; Jumptable for BASIC V2 dialect commands
;

!set ITEM_80 = cmd_end
!set ITEM_81 = cmd_for
!set ITEM_82 = cmd_next
!set ITEM_83 = cmd_data
!set ITEM_84 = cmd_inputhash
!set ITEM_85 = cmd_input
!set ITEM_86 = array_create                      ; cmd_dim
!set ITEM_87 = cmd_read
!set ITEM_88 = assign_variable                   ; cmd_let
!set ITEM_89 = cmd_goto
!set ITEM_8A = cmd_run
!set ITEM_8B = cmd_if
!set ITEM_8C = do_restore                        ; cmd_restore
!set ITEM_8D = cmd_gosub
!set ITEM_8E = cmd_return
!set ITEM_8F = cmd_rem

!set ITEM_90 = cmd_stop
!set ITEM_91 = cmd_on
!set ITEM_92 = cmd_wait
!set ITEM_93 = cmd_load
!set ITEM_94 = cmd_save
!set ITEM_95 = cmd_verify
!set ITEM_96 = cmd_def
!set ITEM_97 = cmd_poke
!set ITEM_98 = cmd_printhash
!set ITEM_99 = cmd_print
!set ITEM_9A = cmd_cont
!set ITEM_9B = cmd_list
!set ITEM_9C = do_clr                            ; cmd_clr
!set ITEM_9D = cmd_cmd
!set ITEM_9E = cmd_sys
!set ITEM_9F = cmd_open

!set ITEM_A0 = cmd_close
!set ITEM_A1 = cmd_get
!set ITEM_A2 = cmd_new
!set ITEM_A3 = cmd_tab                           ; XXX this token probably does not belong here
!set ITEM_A4 = do_SYNTAX_error                   ; 'TO' is not a standalone command
!set ITEM_A5 = do_SYNTAX_error                   ; 'FN' is not a standalone command
!set ITEM_A6 = cmd_spc                           ; XXX this token probably does not belong here
	
	; 'THEN' ($A7) and 'STEP' ($A9) are not standalone commands
	; 'NOT' ($A8) is an operator, not a command

	; 'GO' ($CB) is handled separately


!ifndef HAS_OPCODES_65C02 {

command_jumptable_lo:

	!byte <(ITEM_80-1), <(ITEM_81-1), <(ITEM_82-1), <(ITEM_83-1), <(ITEM_84-1), <(ITEM_85-1), <(ITEM_86-1), <(ITEM_87-1)
	!byte <(ITEM_88-1), <(ITEM_89-1), <(ITEM_8A-1), <(ITEM_8B-1), <(ITEM_8C-1), <(ITEM_8D-1), <(ITEM_8E-1), <(ITEM_8F-1)
	!byte <(ITEM_90-1), <(ITEM_91-1), <(ITEM_92-1), <(ITEM_93-1), <(ITEM_94-1), <(ITEM_95-1), <(ITEM_96-1), <(ITEM_97-1)
	!byte <(ITEM_98-1), <(ITEM_99-1), <(ITEM_9A-1), <(ITEM_9B-1), <(ITEM_9C-1), <(ITEM_9D-1), <(ITEM_9E-1), <(ITEM_9F-1)
	!byte <(ITEM_A0-1), <(ITEM_A1-1), <(ITEM_A2-1), <(ITEM_A3-1), <(ITEM_A4-1), <(ITEM_A5-1), <(ITEM_A6-1)

command_jumptable_hi:

	!byte >(ITEM_80-1), >(ITEM_81-1), >(ITEM_82-1), >(ITEM_83-1), >(ITEM_84-1), >(ITEM_85-1), >(ITEM_86-1), >(ITEM_87-1)
	!byte >(ITEM_88-1), >(ITEM_89-1), >(ITEM_8A-1), >(ITEM_8B-1), >(ITEM_8C-1), >(ITEM_8D-1), >(ITEM_8E-1), >(ITEM_8F-1)
	!byte >(ITEM_90-1), >(ITEM_91-1), >(ITEM_92-1), >(ITEM_93-1), >(ITEM_94-1), >(ITEM_95-1), >(ITEM_96-1), >(ITEM_97-1)
	!byte >(ITEM_98-1), >(ITEM_99-1), >(ITEM_9A-1), >(ITEM_9B-1), >(ITEM_9C-1), >(ITEM_9D-1), >(ITEM_9E-1), >(ITEM_9F-1)
	!byte >(ITEM_A0-1), >(ITEM_A1-1), >(ITEM_A2-1), >(ITEM_A3-1), >(ITEM_A4-1), >(ITEM_A5-1), >(ITEM_A6-1)

} else { ; HAS_OPCODES_65C02

command_jumptable:

	; Note: 65C02 has the page boundary vector bug fixed!

	!word ITEM_80, ITEM_81, ITEM_82, ITEM_83, ITEM_84, ITEM_85, ITEM_86, ITEM_87
	!word ITEM_88, ITEM_89, ITEM_8A, ITEM_8B, ITEM_8C, ITEM_8D, ITEM_8E, ITEM_8F
	!word ITEM_90, ITEM_91, ITEM_92, ITEM_93, ITEM_94, ITEM_95, ITEM_96, ITEM_97
	!word ITEM_98, ITEM_99, ITEM_9A, ITEM_9B, ITEM_9C, ITEM_9D, ITEM_9E, ITEM_9F
	!word ITEM_A0, ITEM_A1, ITEM_A2, ITEM_A3, ITEM_A4, ITEM_A5, ITEM_A6
}
