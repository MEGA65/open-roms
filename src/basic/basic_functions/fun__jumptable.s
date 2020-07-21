// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE

//
// Jumptable for BASIC V2 dialect functions
//


.const function_list = List().add(

	// $B4-$BF

	fun_sgn,
	fun_int,
	fun_abs,
	fun_usr,
	fun_fre,
	fun_pos,
	fun_sqr,
	fun_rnd,
	fun_log,
	fun_exp,
	fun_cos,
	fun_sin,

	// $C0-$CA

	fun_tan,
	fun_atn,
	fun_peek,
	fun_len,
	fun_str,
	fun_val,
	fun_asc,
	fun_chr,
	fun_left,
	fun_right,
	fun_mid
)


#if !HAS_OPCODES_65C02


function_jumptable_lo:

	put_jumptable_lo(function_list)


function_jumptable_hi:

	put_jumptable_hi(function_list)


#else // HAS_OPCODES_65C02

function_jumptable:

	// Note: 65C02 has the page boundary vector bug fixed!
	put_jumptable(function_list)

#endif
