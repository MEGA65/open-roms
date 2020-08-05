// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE


is_var_ST:

	// Always start with VARNAM+1, there is a sligtly bigger chance it won't match

	lda VARNAM+1
	cmp #$54       // 'T'
	bne !+

	lda VARNAM+0
	cmp #$53       // 'S'
!:
	rts
