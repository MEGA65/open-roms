;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

;
; Math package - copy FAC2 to FAC1
;
; Output (found by experimentation):
; - .A - FAC1 exponent
; - .X - always 0
;
; Preserves:
; - .Y
;
; See also:
; - [CM64] Computes Mapping the Commodore 64 - page 115
; - https://www.c64-wiki.com/wiki/Floating_point_arithmetic
; - https://codebase64.org/doku.php?id=base:kernal_floating_point_mathematics
;

mov_FAC2_FAC1:

	; Copy the mantissa

	lda FAC2_mantissa+3
	sta FAC1_mantissa+3
	lda FAC2_mantissa+2
	sta FAC1_mantissa+2
	lda FAC2_mantissa+1
	sta FAC1_mantissa+1
	lda FAC2_mantissa+0
	sta FAC1_mantissa+0

	; Copy the sign

	lda FAC2_sign
	sta FAC1_sign

	; Copy the exponent

	lda FAC2_exponent
	sta FAC1_exponent

	; Clear FACOV

	ldx #$00
	stx FACOV

	rts
