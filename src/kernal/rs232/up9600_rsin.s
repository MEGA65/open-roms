;; #LAYOUT# STD *        #TAKE
;; #LAYOUT# *   KERNAL_0 #TAKE
;; #LAYOUT# *   *        #IGNORE

;
; Get byte from serial interface
;

; Based on UP9600 code by Daniel Dallman with Bo Zimmerman adaptations


!ifdef CONFIG_RS232_UP9600 {


up9600_rsin:

	ldy RIDBS
	cpy RIDBE
	beq up9600_rsin_end;                ; skip (empty buffer, return with carry set)
	
	lda (RIBUF),Y
	iny
	sty RIDBS
	pha                                ; begin buffer emptying chk
	tya
	sec
	sbc RIDBE
	cmp #206                           ; 256-50
	bcc @1
	lda #$02
	ora CIA2_PR ; $DD01
	sta CIA2_PR                        ; enable RTS
	clc

	; FALLTROUGH	
@1:
	pla

	; FALLTROUGH

up9600_rsin_end:

	rts
}
