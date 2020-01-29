// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE

//
// Math package - fetch FAC2 from RAM location
//
// Input:
// - .A - address low byte
// - .Y - address high byte
//
// Output:
// - .A - FAC1 exponent (yes, really - Codebase64 is right)
// - .Y - XXX 0?
//
// Preserves:
// - .X - (experimentation with original routine)
//
// See also:
// - [CM64] Computes Mapping the Commodore 64 - page 114
// - https://www.c64-wiki.com/wiki/Floating_point_arithmetic
// - https://codebase64.org/doku.php?id=base:kernal_floating_point_mathematics
//

// XXX test this

CONUPK:

	// Not sure which temporary variables are used for storage by the original ROMs,
	// but $22/$23 (INDEX+0 and INDEX+1) seem to be good candidates, at least some
	// math routines use them as pointer storage, see:
	// - https://www.c64-wiki.com/wiki/Floating_point_arithmetic
	// - https://www.lemon64.com/forum/viewtopic.php?t=67576&sid=d41e77cdddd28d6f9c9d52ce5b4e8dc3

	sty INDEX+1
	sta INDEX+0

	// Now copy the data from RAM to FAC2, for the format description see:
	// - https://www.c64-wiki.com/wiki/Floating_point_arithmetic#Representation_in_the_C-64

	ldy #$04

	// Copy the mantissa - reverse byte order

	ldy #$04
	lda (INDEX), y
	sta FAC2_mantissa+3

	dey
	lda (INDEX), y
	sta FAC2_mantissa+2

	dey
	lda (INDEX), y
	sta FAC2_mantissa+1

	dey
	lda (INDEX), y
	ora #$80                           // clear the sign bit
	sta FAC2_mantissa+0

	// Copy the sign

	lda (INDEX), y
	bpl !+                             // assumption: non-negative numbers are more frequent
	lda #$FF
	skip_2_bytes_trash_nvz
!:
	lda $00

	sta FAC2_sign

	// Copy the exponent

	dey
	lda (INDEX), y
	sta FAC2_exponent

	// Return the FAC1 exponent

	lda FAC1_exponent
	rts
