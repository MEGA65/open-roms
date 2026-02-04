;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

;
; Math package - multiplies FAC1 by FAC2
;
; Input:
; - .A - must load FAC1 exponent ($61) beforehand to set the zero flag
;
; Note:
; - load FAC2 after FAC1, or mimic the Kernals sign comparison (XXX do we need it?)
;
; See also:
; - [CM64] Computes Mapping the Commodore 64 - page 113 XXX address does not match
; - https://www.c64-wiki.com/wiki/Floating_point_arithmetic
; - https://codebase64.org/doku.php?id=base:kernal_floating_point_mathematics
;

set_FAC1_zero:

	lda #$00
	sta FAC1_exponent

mul_FAC2_FAC1_done:

	rts

mul_FAC2_FAC1:

	; First handle special case of multiplying by 0
	
	lda FAC1_exponent
	beq mul_FAC2_FAC1_done
	
	lda FAC2_exponent
	bne @1
	sta FAC1_exponent
	beq mul_FAC2_FAC1_done
@1:
	; Multiply signs
	
	lda FAC1_sign
	eor FAC2_sign
	sta FAC1_sign
	
	; Add the exponents (subtract the bias) - XXX can this be optimized somehow?

	jsr muldiv_RESHO_set_0

	lda FAC1_exponent
	jsr muldiv_RESHO_01_add_A

	lda FAC2_exponent
	jsr muldiv_RESHO_01_add_A

	lda RESHO+0
	sbc #$80                           ; we need to correct double BIAS
	sta RESHO+0
	bcs @2
	lda RESHO+1
	sbc #$00
	bcc set_FAC1_zero
	sta RESHO+1
@2:
	lda RESHO+1
	+bne overflow_error               ; overflow

	lda RESHO+0
	sta FAC1_exponent

	; Multiply the mantissas

	jsr muldiv_RESHO_set_0
	clc

	; XXX maybe we should preserve .X on stack? this will not cost us too much

	lda FACOV
	jsr mul_FAC2_FAC1_by_A
	jsr mul_FAC2_FAC1_shift
	bcc @3
	inc RESHO+0
@3:
	lda FAC1_mantissa+3
	jsr mul_FAC2_FAC1_by_A
	jsr mul_FAC2_FAC1_shift
	bcc @4
	inc RESHO+0
@4:
	lda FAC1_mantissa+2
	jsr mul_FAC2_FAC1_by_A
	jsr mul_FAC2_FAC1_shift
	bcc @5
	inc RESHO+0
@5:
	lda FAC1_mantissa+1
	jsr mul_FAC2_FAC1_by_A
	jsr mul_FAC2_FAC1_shift
	bcc @6
	inc RESHO+0
@6:
	lda FAC1_mantissa+0
	jsr mul_FAC2_FAC1_by_A
	jsr mul_FAC2_FAC1_shift
	bcc @7
	inc RESHO+0
@7:
	; Copy RESHO to FAC1 mantissa

	lda RESHO+4
	sta FACOV
	lda RESHO+3
	sta FAC1_mantissa+3
	lda RESHO+2
	sta FAC1_mantissa+2
	lda RESHO+1
	sta FAC1_mantissa+1
	lda RESHO+0
	sta FAC1_mantissa+0

	; Correct the exponent

	lda FAC1_exponent
	clc
	adc #$08
	+bcs overflow_error                ; branch if overflow
	sta FAC1_exponent
	jmp normal_FAC1

mul_FAC2_FAC1_by_A:

	beq mul_FAC2_FAC1_by_A_done
	sta INDEX+3

	; Multiply FAC2_mantissa+3

	lda FAC2_mantissa+3
	jsr mul_FAC2_FAC1_8x8

	adc RESHO+4
	sta RESHO+4
	txa
	adc RESHO+3
	sta RESHO+3
	bcc @8
	inc RESHO+2
	bne @8
	inc RESHO+1
	bne @8
	inc RESHO+0
@8:
	; Multiply FAC2_mantissa+2

	lda FAC2_mantissa+2
	jsr mul_FAC2_FAC1_8x8

	adc RESHO+3
	sta RESHO+3
	txa
	adc RESHO+2
	sta RESHO+2
	bcc @9
	inc RESHO+1
	bne @9
	inc RESHO+0
@9:
	; Multiply FAC2_mantissa+1

	lda FAC2_mantissa+1
	jsr mul_FAC2_FAC1_8x8

	adc RESHO+2
	sta RESHO+2
	txa
	adc RESHO+1
	sta RESHO+1
	bcc @10
	inc RESHO+0
@10:
	; Multiply FAC2_mantissa+0

	lda FAC2_mantissa+0
	jsr mul_FAC2_FAC1_8x8
	adc RESHO+1
	sta RESHO+1
	txa
	adc RESHO+0
	sta RESHO+0

	; FALLTROUGH

mul_FAC2_FAC1_by_A_done:

	rts
