;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

;
; Math package - helper routines for RESHO manipulation
;


muldiv_RESHO_set_0:

	lda #$00
	sta RESHO+0
	sta RESHO+1
	sta RESHO+2
	sta RESHO+3
	sta RESHO+4

	rts


muldiv_RESHO_01_add_A:

	clc
	adc RESHO+0
	sta RESHO+0
	bcc @1
	inc RESHO+1
@1:
	rts
