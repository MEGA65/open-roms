// #LAYOUT# STD *       #TAKE
// #LAYOUT# M65 BASIC_1 #TAKE
// #LAYOUT# X16 BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE

//
// Cuts away unnecessary characters after tokenizing a keyword
//


tk_cut_away:

	inc tk__offset
	ldy tk__offset

	dec tk__len_unpacked                         // keyword length, afterwards number of bytes to cut away
	lda tk__len_unpacked
	clc
	adc tk__offset
	tax
!:
	lda BUF, x
	sta BUF, y
	beq !+

	inx
	iny
	bne !-	
!:
	rts
