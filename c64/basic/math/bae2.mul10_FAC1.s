// #LAYOUT# STD *       #TAKE
// #LAYOUT# X16 BASIC_0 #TAKE-OFFSET 2000
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE

//
// Math package - multiply FAC1 by 10
//
// See also:
// - [CM64] Computes Mapping the Commodore 64 - page 114
// - https://www.c64-wiki.com/wiki/Floating_point_arithmetic
// - https://codebase64.org/doku.php?id=base:kernal_floating_point_mathematics
//

mul10_FAC1:

	// Handle special case of FAC1 equal 0

	lda FAC1_exponent
	beq mul10_FAC1_done

	// Start by multiplying FAC1 by 2

	jsr mul10_FAC1_mul2

	// Move FAC1 to FAC2, so that FAC1 = FAC2 = 2 * initial

	jsr mov_FAC1_FAC2

	// Multiply FAC1 by 4

	jsr mul10_FAC1_mul2
	jsr mul10_FAC1_mul2

	// Now we have FAC1 = 8 * initial and FAC2 = 2 * initial; so just add these 2 values

	jmp add_FAC2_FAC1

mul10_FAC1_done:

	rts
