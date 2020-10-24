;; #LAYOUT# M65 *       #TAKE
;; #LAYOUT# *   *       #IGNORE

;
; Jumptable for BASIC commands with tokens prefixed by $04
;

!set ITEM_01 = cmd_sysinfo



!ifndef HAS_OPCODES_65C02 {

command_04_jumptable_lo:

	!byte <(ITEM_01-1)

command_04_jumptable_hi:

	!byte >(ITEM_01-1)

} else { ; HAS_OPCODES_65C02

command_04_jumptable:

	; Note: 65C02 has the page boundary vector bug fixed!

	!word ITEM_01
}
