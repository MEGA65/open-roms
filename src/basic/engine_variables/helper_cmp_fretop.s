// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE

//
// Check string address (DSCPNT+1/+2) vs FRETOP
//
// Output:
// - Zero flag set  - this is the first variable of the string area
// - Carry flag set - this string belongs to the string area


helper_cmp_fretop:

	lda DSCPNT+2
	cmp FRETOP+1
	beq !+
	rts
!:
	lda DSCPNT+1
	cmp FRETOP+0
	rts
