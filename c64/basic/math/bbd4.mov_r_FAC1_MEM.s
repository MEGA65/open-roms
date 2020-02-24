// #LAYOUT# STD *       #TAKE
// #LAYOUT# X16 BASIC_0 #TAKE-OFFSET 2000
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE

//
// Math package - copy FAC1 to memory location, do not round
//
// Input:
// - .X - address low byte
// - .Y - address high byte
//
// Output:
// - .A - FAC1 exponent
//
// See also:
// - https://www.c64-wiki.com/wiki/Floating_point_arithmetic
// - https://codebase64.org/doku.php?id=base:kernal_floating_point_mathematics
//

mov_r_FAC1_MEM:
	
	// Start by rounding FAC1

	jsr round_FAC1
	jmp mov_FAC1_MEM
