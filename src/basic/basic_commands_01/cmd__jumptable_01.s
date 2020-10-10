;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

;
; Jumptable for BASIC commands with tokens prefixed by $01
;


!set ITEM_00 = cmd_slow
!set ITEM_01 = cmd_fast
!set ITEM_02 = cmd_old

	; NOTE! These commands are temporarily placed here, they should be a part of list 02!

!set ITEM_03 = cmd_merge

!set ITEM_04 = cmd_bload
!set ITEM_05 = cmd_bsave
!set ITEM_06 = cmd_bverify

!set ITEM_07 = cmd_clear
!set ITEM_08 = varstr_garbage_collect            ; cmd_dispose


!ifndef HAS_OPCODES_65C02 {

command_01_jumptable_lo:

	!byte <(ITEM_00-1), <(ITEM_01-1), <(ITEM_02-1), <(ITEM_03-1), <(ITEM_04-1), <(ITEM_05-1), <(ITEM_06-1), <(ITEM_07-1), <(ITEM_08-1)


command_01_jumptable_hi:

	!byte >(ITEM_00-1), >(ITEM_01-1), >(ITEM_02-1), >(ITEM_03-1), >(ITEM_04-1), >(ITEM_05-1), >(ITEM_06-1), >(ITEM_07-1), >(ITEM_08-1)

} else { ; HAS_OPCODES_65C02

command_01_jumptable:

	; Note: 65C02 has the page boundary vector bug fixed!

	!word ITEM_00, ITEM_01, ITEM_02, ITEM_03, ITEM_04, ITEM_05, ITEM_06, ITEM_07, ITEM_08
}
