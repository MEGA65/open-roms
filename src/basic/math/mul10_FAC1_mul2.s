;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

;
; Multiply FAC1 by 2, do not normalize
;

mul10_FAC1_mul2:

	; Increment the exponent

	inc FAC1_exponent
	+beq set_FAC1_max

	rts
