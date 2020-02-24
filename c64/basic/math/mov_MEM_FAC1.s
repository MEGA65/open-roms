// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE

// Math package - fetch FAC1 from RAM location
//
// Input:
// - .A - address low byte
// - .Y - address high byte
//
// Output:
// - .A - FAC1 exponent, affects status flags
// - .Y - always 0
//
// Preserves:
// - .X - (experimentation with original ROM)
//
// See also:
// - https://www.c64-wiki.com/wiki/Floating_point_arithmetic
// - https://codebase64.org/doku.php?id=base:kernal_floating_point_mathematics

// XXX test this

mov_MEM_FAC1:

	// Original routines use $22/$23 location for a vector too, see here:
	// - https://codebase64.org/doku.php?id=base:kernal_floating_point_mathematics

	sty INDEX+1
	sta INDEX+0

	// Now copy the data from RAM to FAC2, for the format description see:
	// - https://www.c64-wiki.com/wiki/Floating_point_arithmetic#Representation_in_the_C-64

	// Copy the mantissa

	ldy #$04
	lda (INDEX), y
	sta FAC1_mantissa+3

	dey
	lda (INDEX), y
	sta FAC1_mantissa+2

	dey
	lda (INDEX), y
	sta FAC1_mantissa+1

	dey
	lda (INDEX), y
	ora #$80                           // clear the sign bit
	sta FAC1_mantissa+0

	// Copy the sign

	lda (INDEX), y
	bpl !+                             // assumption: non-negative numbers are more frequent
	lda #$FF
	skip_2_bytes_trash_nvz
!:
	lda #$00

	sta FAC1_sign

	// Copy the exponent

	dey
	lda (INDEX), y
	sta FAC1_exponent

	// Set low order mantissa to 0 - this should give the
	// most precision while operating on integers

	sty FACOV

	// Return the FAC1 exponent

	lda FAC1_exponent
	rts
