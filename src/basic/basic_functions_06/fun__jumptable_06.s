;; #LAYOUT# M65 BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

;
; Jumptable for BASIC commands with tokens prefixed by $03
;

!set ITEM_01 = do_NOT_IMPLEMENTED_error          ; just for testing


!ifndef HAS_OPCODES_65C02 {

function_06_jumptable_lo:

	!byte <(ITEM_01-1)

function_06_jumptable_hi:

	!byte >(ITEM_01-1)

} else { ; HAS_OPCODES_65C02

function_06_jumptable:

	; Note: 65C02 has the page boundary vector bug fixed!
	
	!word ITEM_01
}
