// #LAYOUT# STD *       #TAKE
// #LAYOUT# X16 BASIC_0 #TAKE-OFFSET 2000
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE

//
// Math package - toggle FAC1 sign (if not 0)
//
// See also:
// - [CM64] Computes Mapping the Commodore 64 - page 117
// - https://www.c64-wiki.com/wiki/Floating_point_arithmetic
//

toggle_sign_FAC1:

	lda FAC1_exponent
	beq !+                             // do not toggle the sign if value is 0

	// FALLTROUGH

toggle_sign_FAC1_skipcheck:            // entry for other routines

	lda FAC1_sign
	eor #$FF
	sta FAC1_sign
!:
	rts
