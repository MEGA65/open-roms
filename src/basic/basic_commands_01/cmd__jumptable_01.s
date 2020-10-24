;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

;
; Jumptable for BASIC commands with tokens prefixed by $01
;

!set ITEM_01 = cmd_slow
!set ITEM_02 = cmd_fast
!set ITEM_03 = cmd_old

!ifndef HAS_SMALL_BASIC {

!set ITEM_04 = cmd_clear
!set ITEM_05 = varstr_garbage_collect            ; cmd_dispose
!set ITEM_06 = cmd_merge
!set ITEM_07 = cmd_bload
!set ITEM_08 = cmd_bsave
!set ITEM_09 = cmd_bverify
!set ITEM_0A = cmd_cold
!set ITEM_0B = cmd_mem

}



!ifndef HAS_OPCODES_65C02 {

command_01_jumptable_lo:

	!byte <(ITEM_01-1), <(ITEM_02-1), <(ITEM_03-1)

!ifndef HAS_SMALL_BASIC {
	!byte <(ITEM_04-1), <(ITEM_05-1), <(ITEM_06-1), <(ITEM_07-4), <(ITEM_08-1), <(ITEM_09-1), <(ITEM_0A-1), <(ITEM_0B-1)
}

command_01_jumptable_hi:

	!byte >(ITEM_01-1), >(ITEM_02-1), >(ITEM_03-1)

!ifndef HAS_SMALL_BASIC {
	!byte >(ITEM_04-1), >(ITEM_05-1), >(ITEM_06-1), >(ITEM_07-4), >(ITEM_08-1), >(ITEM_09-1), >(ITEM_0A-1), >(ITEM_0B-1)
}

} else { ; HAS_OPCODES_65C02

command_01_jumptable:

	; Note: 65C02 has the page boundary vector bug fixed!

	!word ITEM_01, ITEM_02, ITEM_03

!ifndef HAS_SMALL_BASIC {
	!word ITEM_04, ITEM_05, ITEM_06, ITEM_07, ITEM_08, ITEM_09, ITEM_0A, ITEM_0B
}

}
