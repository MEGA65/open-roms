;; #LAYOUT# STD *        #TAKE
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *        #IGNORE


; minimal integer-only add (see intmath.s)

!ifdef CONFIG_BASIC_MINIMAL_INTMATH {

oper_add:

	jsr pop_fac2_value                   ; second operand -> FAC2

	jsr fac2_to_int16                  ; X = hi, A = lo
	bcs oper_add_bad

	; Save the second operand in FAC2 mantissa low bytes

	stx __FAC2+3
	sta __FAC2+4

	jsr fac1_to_int16                  ; X = hi, A = lo
	bcs oper_add_bad

	; 16 bit add (wraps on overflow)

	clc
	adc __FAC2+4
	pha
	txa
	adc __FAC2+3
	tax
	pla

	jsr int16_to_fac1

	jmp FRMEVL_continue

oper_add_bad:

	jmp do_NOT_IMPLEMENTED_error

} else {

oper_add:

	; XXX provide implementation

	jmp do_NOT_IMPLEMENTED_error

} ; CONFIG_BASIC_MINIMAL_INTMATH
