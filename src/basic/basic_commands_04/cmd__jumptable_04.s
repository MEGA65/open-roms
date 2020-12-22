;; #LAYOUT# M65 BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

;
; Jumptable for BASIC commands with tokens prefixed by $04
;

!set ITEM_01 = cmd_sysinfo
!set ITEM_02 = cmd_monitor
!set ITEM_03 = BOOTCPM
!set ITEM_04 = cmd_joycrsr


!ifndef HAS_OPCODES_65C02 {

command_04_jumptable_lo:

	!byte <(ITEM_01-1)
	!byte <(ITEM_02-1)
	!byte <(ITEM_03-1)

command_04_jumptable_hi:

	!byte >(ITEM_01-1)
	!byte >(ITEM_02-1)
	!byte >(ITEM_03-1)

} else { ; HAS_OPCODES_65C02

command_04_jumptable:

	; Note: 65C02 has the page boundary vector bug fixed!

	!word ITEM_01
	!word ITEM_02
	!word ITEM_03
	!word ITEM_04
}
