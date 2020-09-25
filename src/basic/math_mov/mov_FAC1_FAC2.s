;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

;
; Math package - move FAC1 to FAC2
;
; Output (all found by experimentation):
; - .A - FAC1 exponent
; - .X - always 0
;
; Preserves (found by experimentation):
; - .Y
;
; Note:
; - observed that original ROM always clears FACOV, not sure why
;
; See also:
; - [CM64] Computes Mapping the Commodore 64 - page 115
; - https://www.c64-wiki.com/wiki/BASIC-ROM
; - https://www.c64-wiki.com/wiki/Floating_point_arithmetic
;

mov_FAC1_FAC2:

	; Copy the exponent
	lda FAC1_exponent
	sta FAC2_exponent
	beq @1                             ; for 0 no need to copy mantissa and sign

	; Copy the mantissa
	lda FAC1_mantissa+0
	sta FAC2_mantissa+0
	lda FAC1_mantissa+1
	sta FAC2_mantissa+1
	lda FAC1_mantissa+2
	sta FAC2_mantissa+2
	lda FAC1_mantissa+3
	sta FAC2_mantissa+3

	; Copy the sign
	lda FAC1_sign
	sta FAC2_sign

	lda FAC1_exponent
@1:
	; Duplicate the original ROM behaviour
	ldx #$00
	stx FACOV

	rts
