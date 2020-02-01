// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE

//
// Math package - divide RAM by FAC1
//
// Input:
// - .A - address low byte
// - .Y - address high byte
//
// See also:
// - [CM64] Computes Mapping the Commodore 64 - page 114
// - https://www.c64-wiki.com/wiki/Floating_point_arithmetic
// - https://codebase64.org/doku.php?id=base:kernal_floating_point_mathematics
//

div_MEM_FAC1:

	jsr mov_MEM_FAC2

	// FALLTROUGH to div_FAC2_FAC1
