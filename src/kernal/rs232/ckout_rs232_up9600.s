;; #LAYOUT# STD *        #TAKE
;; #LAYOUT# *   KERNAL_0 #TAKE
;; #LAYOUT# *   *        #IGNORE

;
; RS-232 part of the CKOUT routine
;

; Based on UP9600 code by Daniel Dallman with Bo Zimmerman adaptations


!ifdef CONFIG_RS232_UP9600 {


ckout_rs232:

	; XXX adapt this

	lda #$02
	sta DFLTO
	jsr ENABLE
	clc
	rts


} ; CONFIG_RS232_UP9600
