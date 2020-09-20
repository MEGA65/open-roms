;; #LAYOUT# M65 BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

!ifndef CONFIG_MEMORY_MODEL_46K_OR_50K {

helper_if_mega65:

	; Injest all spaces

	ldy #$00
@1:
	lda (TXTPTR), Y
	cmp #$20
	bne @2
	inw TXTPTR
	bra @1
@2:

	; Check for MEGA65 untokenized keyword

	ldy #$05
@3:
	lda (TXTPTR), Y
	cmp str_mega65, Y
	+bne helper_if_mega65_fail
	dey
	bpl @3

	; Increment TXTPTR by 6

	clc
	lda TXTPTR+0
	adc #$06
	sta TXTPTR+0
	bcc @4
	inc TXTPTR+1
@4:
	; Report successful check

	clc
	rts

helper_if_mega65_fail:

	sec
	rts

str_mega65:

	!byte $4D, $45, $47, $41, $36, $35
}
