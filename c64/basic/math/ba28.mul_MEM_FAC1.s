// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE

//
// Math package - multiplies FAC1 by RAM
//
// Input:
// - .A - address low byte
// - .Y - address high byte
//
// Note:
// - C64 Wiki calls it FMULT, this looks like a mistake
//
// See also:
// - [CM64] Computes Mapping the Commodore 64 - page 113
// - https://www.c64-wiki.com/wiki/Floating_point_arithmetic
// - https://codebase64.org/doku.php?id=base:kernal_floating_point_mathematics
//

mul_MEM_FAC1:

	jsr mov_MEM_FAC2

	// FALLTROUGH to mul_FAC2_FAC1
