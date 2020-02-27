// #LAYOUT# STD *       #TAKE
// #LAYOUT# X16 BASIC_0 #TAKE-OFFSET 2000
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE

//
// Math package - set FAC1 as RAM raised to the power of FAC2
//
// Input:
// - .A - address low byte
// - .Y - address high byte
//
// See also:
// - [CM64] Computes Mapping the Commodore 64 - page 117 (FPWRT)
// - https://www.c64-wiki.com/wiki/BASIC-ROM
// - https://www.c64-wiki.com/wiki/Floating_point_arithmetic
// - https://codebase64.org/doku.php?id=base:kernal_floating_point_mathematics
//

pwr_FAC2_MEM:

	jsr mov_MEM_FAC1

	// FALLTROUGH to pwr_FAC2_FAC1
