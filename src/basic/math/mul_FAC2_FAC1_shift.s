;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

;
; Shift RESHO by one byte - for multiplication
;

mul_FAC2_FAC1_shift:

	; Check if rounding is needed

	php
	clc
	lda RESHO+4
	bpl @1
	sec
@1:
	; Copy bytes

	lda RESHO+3
	sta RESHO+4
	lda RESHO+2
	sta RESHO+3
	lda RESHO+1
	sta RESHO+2
	lda RESHO+0
	sta RESHO+1
	lda #$00
	sta RESHO+0
	bcc @2

	; Perform rounding

	inc RESHO+4
	bne @2
	inc RESHO+3
	bne @2
	inc RESHO+2
	bne @2
	inc RESHO+1
	bne @2
	inc RESHO+0
@2:
	plp
	rts
