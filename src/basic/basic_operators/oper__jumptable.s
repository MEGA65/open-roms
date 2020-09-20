;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

;
; Jumptable and priority list for all BASIC operators
;

	; Tokens $AA-$AF

!set ITEM_00 = oper_add
!set ITEM_01 = oper_sub
!set ITEM_02 = oper_mul
!set ITEM_03 = oper_div
!set ITEM_04 = oper_pow
!set ITEM_05 = oper_and

	; Tokens $B0-$B3

!set ITEM_06 = oper_or
!set ITEM_07 = oper_cmp_gt
!set ITEM_08 = oper_cmp_eq
!set ITEM_09 = oper_cmp_lt

	; Combined two tokens

!set ITEM_0A = oper_cmp_gteq
!set ITEM_0B = oper_cmp_lteq
!set ITEM_0C = oper_cmp_neq

	; Unary operators

!set ITEM_0D = oper_unary_minus
!set ITEM_0E = oper_unary_not


operator_priorities:                   ; higher number = higher priority

	!byte $05 ; oper_add
	!byte $05 ; oper_sub
	!byte $06 ; oper_mul
	!byte $06 ; oper_div
	!byte $08 ; oper_pow
	!byte $02 ; oper_and
	!byte $01 ; oper_or
	!byte $04 ; oper_cmp_gt
	!byte $04 ; oper_cmp_eq
	!byte $04 ; oper_cmp_lt
	!byte $04 ; oper_cmp_gteq
	!byte $04 ; oper_cmp_lteq
	!byte $04 ; oper_cmp_neq
	!byte $07 ; oper_unary_minus
	!byte $03 ; oper_unary_not	


operator_jumptable_lo:

	!byte <(ITEM_00-1), <(ITEM_01-1), <(ITEM_02-1), <(ITEM_03-1), <(ITEM_04-1), <(ITEM_05-1), <(ITEM_06-1), <(ITEM_07-1)
	!byte <(ITEM_08-1), <(ITEM_09-1), <(ITEM_0A-1), <(ITEM_0B-1), <(ITEM_0C-1), <(ITEM_0D-1), <(ITEM_0E-1)


operator_jumptable_hi:

	!byte >(ITEM_00-1), >(ITEM_01-1), >(ITEM_02-1), >(ITEM_03-1), >(ITEM_04-1), >(ITEM_05-1), >(ITEM_06-1), >(ITEM_07-1)
	!byte >(ITEM_08-1), >(ITEM_09-1), >(ITEM_0A-1), >(ITEM_0B-1), >(ITEM_0C-1), >(ITEM_0D-1), >(ITEM_0E-1)
