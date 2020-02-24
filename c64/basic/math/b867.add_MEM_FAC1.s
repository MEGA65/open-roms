// #LAYOUT# STD *       #TAKE
// #LAYOUT# X16 BASIC_0 #TAKE-OFFSET 2000
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE

//
// Math package - add memory variable to FAC1
//
// Input:
// - .A - address low byte
// - .Y - address high byte
//
// See also:
// - [CM64] Computes Mapping the Commodore 64 - page 112
// - https://www.c64-wiki.com/wiki/Floating_point_arithmetic
// - https://codebase64.org/doku.php?id=base:kernal_floating_point_mathematics
//

add_MEM_FAC1:

	jsr mov_MEM_FAC2

	// FALLTROUGH to add_FAC2_FAC1
