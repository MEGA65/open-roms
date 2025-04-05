;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# X16 BASIC_0 #TAKE-OFFSET 2000
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

; Math package - Mov MEM to FAC1 with address in INDEX zero page register
;
; See also:
; - https://sourceforge.net/p/acme-crossass/code-0/38/tree/trunk/ACME_Lib/cbm/c64/float.a?force=True
;

get_FAC1_via_INDEX:

	; Copy the mantissa

	ldy #$04
	lda (INDEX), y
	sta FAC1_mantissa+3

	dey
	lda (INDEX), y
	sta FAC1_mantissa+2

	dey
	lda (INDEX), y
	sta FAC1_mantissa+1

	dey
	lda (INDEX), y
	sta FAC1_sign
	ora #$80                           ; clear the sign bit
	sta FAC1_mantissa+0

	; Copy the exponent

	dey
	lda (INDEX), y
	sta FAC1_exponent

	; Set low order mantissa to 0 - this should give the
	; most precision while operating on integers

	sty FACOV

	rts
