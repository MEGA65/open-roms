// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE

//
// Shift RESHO by one byte - for multiplication
//

mul_FAC2_FAC1_shift:

	lda RESHO+3
	sta RESHO+4
	lda RESHO+2
	sta RESHO+3
	lda RESHO+1
	sta RESHO+2
	lda RESHO+0
	sta RESHO+1
	lda #$00
	sta RESHO+0

	rts
