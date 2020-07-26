// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE


check_stack_space:

	tsx
	cpx #$60                           // XXX is this a safe threshold?
	bcc_16 do_FORMULA_TOO_COMPLEX_error

	rts
