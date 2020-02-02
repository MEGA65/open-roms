// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE

//
// Math package - move FAC1 (rounds) to memory variable
//
// Input:
// - FORPNT ($49/$4A) - variable address
//
// See also:
// - https://www.c64-wiki.com/wiki/BASIC-ROM
//

mov_r_FAC1_VAR:

	ldy #FORPNT+1
	ldx #FORPNT+0

	// FALLTROUGH to mov_r_FAC1_MEM
