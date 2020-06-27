// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE

//
// Jumptable and priority list for all BASIC operators
//


.const operator_list = List().add(

	// Tokens $AA-$B0

	oper_add,                          // ID: $00
	oper_sub,                          // ID: $01
	oper_mul,                          // ID: $02
	oper_div,                          // ID: $03
	oper_pow,                          // ID: $04
	oper_and,                          // ID: $05
	oper_or,                           // ID: $06

	// Tokens $B1-$B3

	oper_cmp_gt,                       // ID: $07
	oper_cmp_eq,                       // ID: $08
	oper_cmp_lt,                       // ID: $09

	// Combined two tokens

	oper_cmp_gteq,                     // ID: $0A
	oper_cmp_lteq,                     // ID: $0B
	oper_cmp_neq,                      // ID: $0C

	// Unary operators

	oper_unary_minus,                  // ID: $0D
	oper_unary_not                     // ID: $0E
)


operator_priorities:                   // higher number = higher priority

	.byte $05 // oper_add
	.byte $05 // oper_sub
	.byte $06 // oper_mul
	.byte $06 // oper_div
	.byte $08 // oper_pow
	.byte $02 // oper_and
	.byte $01 // oper_or
	.byte $04 // oper_cmp_gt
	.byte $04 // oper_cmp_eq
	.byte $04 // oper_cmp_lt
	.byte $04 // oper_cmp_gteq
	.byte $04 // oper_cmp_lteq
	.byte $04 // oper_cmp_neq
	.byte $07 // oper_unary_minus
	.byte $03 // oper_unary_not	



operator_jumptable_lo:

	put_jumptable_lo(operator_list)


operator_jumptable_hi:

	put_jumptable_hi(operator_list)
