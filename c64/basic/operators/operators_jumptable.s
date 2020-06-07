// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE

//
// Jumptable and priority list for all BASIC operators
//


.const operator_list = List().add(

	// Tokens XXX

	oper_add,
	oper_sub,
	oper_mul,
	oper_div,

	// Tokens XXX

	oper_and,
	oper_or,

	// Tokens XXX

	oper_cmp_gt,
	oper_cmp_eq,
	oper_cmp_lt,

	// Combined two tokens

	oper_cmp_gteq,
	oper_cmp_lteq,
	oper_cmp_neq,

	// Not a token

	oper_pow,

	// Unary

	oper_unary_minus,
	oper_unary_not
)


operator_priorities:                   // higher number = higher priority

	.byte $05 // oper_add
	.byte $05 // oper_sub
	.byte $06 // oper_mul
	.byte $06 // oper_div
	.byte $02 // oper_and
	.byte $01 // oper_or
	.byte $04 // oper_cmp_gt
	.byte $04 // oper_cmp_eq
	.byte $04 // oper_cmp_lt
	.byte $04 // oper_cmp_gteq
	.byte $04 // oper_cmp_lteq
	.byte $04 // oper_cmp_neq
	.byte $08 // oper_pow
	.byte $07 // oper_unary_minus
	.byte $03 // oper_unary_not	



operator_jumptable_lo:

	put_jumptable_lo(operator_list)


operator_jumptable_hi:

	put_jumptable_hi(operator_list)
