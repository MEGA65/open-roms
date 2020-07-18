// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE


oper_add:

	// This operator can be used either with two strings, or with two floats
	// First check whether arguments match and then choose the variant

	pla
	cmp VALTYP
	bne_16 do_TYPE_MISMATCH_error

	lda VALTYP
	bmi oper_add_strings

	// FALLTROUGH

oper_add_floats:

	// XXX implement this

	jmp do_NOT_IMPLEMENTED_error

oper_add_strings:

	// Retrieve string address

	pla
	sta __FAC2+2
	pla
	sta __FAC2+1

	// Pull string length

	pla
	sta __FAC2+0
	beq oper_add_strings_end           // if string 2 is empty, we have nothing to do

	// If string 1 is empty, just copy the metadata

	lda __FAC1+0
	bne !+

	lda __FAC2+0
	sta __FAC1+0
	lda __FAC2+1
	sta __FAC1+1
	lda __FAC2+2
	sta __FAC1+2

	jmp FRMEVL_continue
!:
	// Allocate memory for concatenated string

	clc
	adc __FAC2+0
	bcs_16 do_STRING_TOO_LONG_error

.break

	jsr tmpstr_alloc




	// XXX finish the implementation


oper_add_strings_end:

	jmp FRMEVL_continue
