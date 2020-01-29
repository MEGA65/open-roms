// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE

//
// Math package - toggle FAC1 sign (if not 0)
//
// See also:
// - [CM64] Computes Mapping the Commodore 64 - page 117
// - https://www.c64-wiki.com/wiki/Floating_point_arithmetic
//

NEGOP:

	lda FAC1_exponent
	beq !+                             // do not toggle the sign if value is 0

	lda FAC1_sign
	eor #$FF
	sta FAC1_sign
!:
	rts
