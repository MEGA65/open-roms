;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# X16 BASIC_0 #TAKE-OFFSET 2000
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

;
; Math package - add FAC2 to FAC1, subtraction part
;

; XXX test this

add_FAC2_FAC1_sub:

	; First verify that |FAC1| > |FAC2|, branch to proper variant if it is not
	; We ignore FACOV here. Note, that exponents are already equalized

	lda FAC1_mantissa+0
	cmp FAC2_mantissa+0
	bcc add_FAC2_FAC1_sub_rev          ; if FAC1 < FAC2, branch
	bne @1                             ; if FAC1 > FAC2, branch

	lda FAC1_mantissa+1
	cmp FAC2_mantissa+1
	bcc add_FAC2_FAC1_sub_rev          ; if FAC1 < FAC2, branch
	bne @1                             ; if FAC1 > FAC2, branch

	lda FAC1_mantissa+2
	cmp FAC2_mantissa+2
	bcc add_FAC2_FAC1_sub_rev          ; if FAC1 < FAC2, branch
	bne @1                             ; if FAC1 > FAC2, branch

	lda FAC1_mantissa+3
	cmp FAC2_mantissa+3
	bcc add_FAC2_FAC1_sub_rev          ; if FAC1 < FAC2, branch
	bne @1                             ; if FAC1 > FAC2, branch

	; If we are here, than FAC1 is equal to FAC2 - so just set FAC1 to 0
	
	lda #$00
	sta FAC1_exponent
	rts
@1:
	; Perform the subtration, FAC1 = FAC1 - FAC2

	sec
	lda FAC1_mantissa+3
	sbc FAC2_mantissa+3
	sta FAC1_mantissa+3

	lda FAC1_mantissa+2
	sbc FAC2_mantissa+2
	sta FAC1_mantissa+2
	
	lda FAC1_mantissa+1
	sbc FAC2_mantissa+1
	sta FAC1_mantissa+1	

	lda FAC1_mantissa+0
	sbc FAC2_mantissa+0
	sta FAC1_mantissa+0	
	
	; Exponent should never need adaptation here
	
	jmp normal_FAC1

add_FAC2_FAC1_sub_rev:

	; Since |FAC1| < |FAC2|, toggle FAC1 sign before subtraction

	jsr toggle_sign_FAC1_skipcheck

	; Perform the subtration, FAC1 = FAC2 - FAC1
	
	sec
	lda #$00
	sbc FACOV
	sta FACOV
	
	lda FAC2_mantissa+3
	sbc FAC1_mantissa+3
	sta FAC1_mantissa+3

	lda FAC2_mantissa+2
	sbc FAC1_mantissa+2
	sta FAC1_mantissa+2
	
	lda FAC2_mantissa+1
	sbc FAC1_mantissa+1
	sta FAC1_mantissa+1	

	lda FAC2_mantissa+0
	sbc FAC1_mantissa+0
	sta FAC1_mantissa+0
	
	; Exponent should never need adaptation here

	jmp normal_FAC1
