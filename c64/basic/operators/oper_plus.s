// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE


oper_plus:

	// This operator can be used either with two strings, or with two floats
	// First check whether arguments match and then choose the variant

	pla
	cmp VALTYP
	bne_16 do_TYPE_MISMATCH_error

	lda VALTYP
	bmi oper_plus_strings

	// FALLTROUGH

oper_plus_floats:

	// XXX implement this

	jmp do_NOT_IMPLEMENTED_error

oper_plus_strings:

	// Pull string length

	pla
	sta __FAC2+0

	// Retrieve string address

	pla
	sta __FAC2+2
	pla
	sta __FAC2+1

	// XXX merge strings here

	jmp FRMEVL_calculate
