;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# X16 BASIC_0 #TAKE-OFFSET 2000
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

;
; Math package - Mov MEM to FAC2 with address in INDEX zero page register
;
; See also:
; - https://sourceforge.net/p/acme-crossass/code-0/38/tree/trunk/ACME_Lib/cbm/c64/float.a?force=True
;

; XXX implement, test

get_FAC2_via_INDEX:

	; Now copy the data from RAM to FAC2, for the format description see:
	; - https://www.c64-wiki.com/wiki/Floating_point_arithmetic#Representation_in_the_C-64

	; Copy the mantissa

	ldy #$04
	lda (INDEX), y
	sta FAC2_mantissa+3

	dey
	lda (INDEX), y
	sta FAC2_mantissa+2

	dey
	lda (INDEX), y
	sta FAC2_mantissa+1

	dey
	lda (INDEX), y
	ora #$80                           ; clear the sign bit
	sta FAC2_mantissa+0

	; Copy the sign

	lda (INDEX), y
	bpl @1                             ; assumption: non-negative numbers are more frequent
	lda #$FF
	+skip_2_bytes_trash_nvz
@1:
	lda #$00

	sta FAC2_sign

	; Copy the exponent

	dey
	lda (INDEX), y
	sta FAC2_exponent

	; Return the FAC1 exponent

	lda FAC1_exponent
	rts
