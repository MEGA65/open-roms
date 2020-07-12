// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE

//
// Helper compare subroutine for 'print_integer'
//

print_integer_compare:

	lda FAC1_exponent+1
	cmp print_integer_tab_hi, y
	bne !+

	lda FAC1_exponent+0
	cmp print_integer_tab_lo, y
!:
	rts
