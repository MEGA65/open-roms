;; #LAYOUT# M65 BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

;
; Jumptable for BASIC commands with tokens prefixed by $03
;

!set ITEM_00 = cmd_rem                           ; XXX just for testing


command_03_jumptable:

	; Note: 65C02 has the page boundary vector bug fixed!

	!word ITEM_00
