;; #LAYOUT# STD *        #TAKE
;; #LAYOUT# *   KERNAL_0 #TAKE
;; #LAYOUT# *   *        #IGNORE

;
; RS-232 part of the CHKIN routine
;

; Based on UP9600 code by Daniel Dallman with Bo Zimmerman adaptations


!ifdef CONFIG_RS232_UP9600 {


; XXX get rid of the ENABLE/DISABLE mechanism


chkin_rs232:

	pha
	lda XXX_UPFLAG
	bne @1
	pla
	jmp $F20E ; XXX
	
@1:
	pla
	jsr $F30F ; XXX
	beq @2
	jmp $F701 ; XXX

@2:
	jsr $F31F ; XXX
	lda FA
	cmp #$02
	beq @3
	cmp #$04
	bcc chkin_rs232_nochkin
	jsr XXX_DISABLE
	jmp chkin_rs232_nochkin
@3:
	sta $99
	jsr XXX_ENABLE
	clc
	rts

chkin_rs232_nochkin:
	jmp $F219 ; XXX


} ; CONFIG_RS232_UP9600
