// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE

//
// Math package - subtract FAC1 from memory variable
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

sub_MEM_FAC1:

	jsr mov_MEM_FAC2

	// FALLTROUGH to sub_FAC2_FAC1
