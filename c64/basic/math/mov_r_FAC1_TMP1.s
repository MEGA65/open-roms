// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE

//
// Math package - store FAC1 (rounds) in TEMPF1
//
// See also:
// - https://www.c64-wiki.com/wiki/BASIC-ROM
// - https://sta.c64.org/cbm64basconv.html
//

mov_r_FAC1_TMP1:

	ldy #$00
	ldx #$5C

	jmp mov_r_FAC1_MEM
