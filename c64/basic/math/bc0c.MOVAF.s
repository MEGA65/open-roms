// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE

//
// Math package - round and move FAC1 to FAC2
//
// Output:
// - .A - FAC1 exponent
//
// See also:
// - [CM64] Computes Mapping the Commodore 64 - page 115
// - https://www.c64-wiki.com/wiki/BASIC-ROM
// - https://www.c64-wiki.com/wiki/Floating_point_arithmetic
//

MOVAF:

	// First round FAC1
	jsr ROUND

	// FALLTROUGH to MOVFA