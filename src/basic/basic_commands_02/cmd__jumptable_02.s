;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

;
; Jumptable for BASIC commands with tokens prefixed by $02
;

!ifndef HAS_SMALL_BASIC {

	; NOTE! These commands are temporarily placed in list 01!

	; cmd_merge,

	; cmd_bload,
	; cmd_bsave,
	; cmd_bverify,

	; cmd_clear,
	; varstr_garbage_collect,            ; cmd_dispose

!set ITEM_00 = cmd_cold
!set ITEM_01 = cmd_mem

!ifdef CONFIG_MB_M65 {
!set ITEM_02 = cmd_sysinfo
}

!ifndef HAS_OPCODES_65C02 {

command_02_jumptable_lo:

	!byte <(ITEM_00-1), <(ITEM_01-1)
	!ifdef CONFIG_MB_M65 { !byte <(ITEM_02-1) }

command_02_jumptable_hi:

	!byte >(ITEM_00-1), >(ITEM_01-1)
	!ifdef CONFIG_MB_M65 { !byte >(ITEM_02-1) }

} else { ; HAS_OPCODES_65C02

command_02_jumptable:

	; Note: 65C02 has the page boundary vector bug fixed!

	!word ITEM_00, ITEM_01
	!ifdef CONFIG_MB_M65 { !word ITEM_02 }
} }
