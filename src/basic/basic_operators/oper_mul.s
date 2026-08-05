;; #LAYOUT# STD *        #TAKE
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *        #IGNORE


; minimal integer-only multiply (see intmath.s);
; pops the second operand pushed by FRMEVL into FAC2, multiplies the two
; 16 bit unsigned integers, keeps the low 16 bits of the product

!ifdef CONFIG_BASIC_MINIMAL_INTMATH {

oper_mul:

	jsr pop_fac2_value                   ; second operand -> FAC2

	; Convert FAC2 operand to integer, move it to vb_hi ($6E) / vb_lo ($66)

	jsr fac2_to_int16
	bcs oper_mul_bad

	stx __FAC2+5                       ; vb_hi = $6E
	sta __FAC1+5                       ; vb_lo = $66

	; Convert FAC1 operand to integer, use it as the shifted multiplicand
	; in __FAC2+1..+4 (32 bit, big endian)

	jsr fac1_to_int16                  ; X = hi, A = lo
	bcs oper_mul_bad

	stx __FAC2+3
	sta __FAC2+4
	lda #$00
	sta __FAC2+1
	sta __FAC2+2

	; 32 bit result in __FAC1+1..+4, initially 0

	sta __FAC1+1
	sta __FAC1+2
	sta __FAC1+3
	sta __FAC1+4

	ldy #$10                           ; 16 bits to process

@loop:
	; vb >>= 1, if bit 0 was set: result += multiplicand

	lsr __FAC2+5
	ror __FAC1+5
	bcc @no_add

	lda __FAC1+4
	clc
	adc __FAC2+4
	sta __FAC1+4
	lda __FAC1+3
	adc __FAC2+3
	sta __FAC1+3
	lda __FAC1+2
	adc __FAC2+2
	sta __FAC1+2
	lda __FAC1+1
	adc __FAC2+1
	sta __FAC1+1

@no_add:
	; multiplicand <<= 1

	asl __FAC2+4
	rol __FAC2+3
	rol __FAC2+2
	rol __FAC2+1

	dey
	bne @loop

	; Result = low 16 bits of the product

	ldx __FAC1+3
	lda __FAC1+4
	jsr int16_to_fac1

	jmp FRMEVL_continue

oper_mul_bad:

	jmp do_NOT_IMPLEMENTED_error

} else {

oper_mul:

	; XXX provide implementation

	jmp do_NOT_IMPLEMENTED_error

} ; CONFIG_BASIC_MINIMAL_INTMATH
