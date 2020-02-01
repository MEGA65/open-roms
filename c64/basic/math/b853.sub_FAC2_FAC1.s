// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE

//
// Math package - subtract FAC1 from FAC2
//
// See also:
// - [CM64] Computes Mapping the Commodore 64 - page 112
// - https://www.c64-wiki.com/wiki/Floating_point_arithmetic
// - https://codebase64.org/doku.php?id=base:kernal_floating_point_mathematics
//

// XXX test this

sub_FAC2_FAC1:

	// Toggle FAC1 sign
	lda FAC1_sign
	eor #$FF
	sta FAC1_sign

	// Perform addition
	jmp add_FAC2_FAC1
