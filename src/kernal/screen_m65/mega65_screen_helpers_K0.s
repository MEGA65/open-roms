;; #LAYOUT# M65 KERNAL_0 #TAKE
;; #LAYOUT# *   *        #IGNORE

;
; Set the INDX variable - logical row length
;

m65_screen_set_indx: ; leaves value in .A

    lda M65_SCRWINMODE
    bmi @1

    ; Non-windowed mode

    phx
	ldx M65_SCRMODE
	lda m65_scrtab_txtwidth,x
	dec
	sta INDX
	plx
	rts
@1:
	; Windowed mode

	sec
	lda M65_TXTWIN_X1
	sbc M65_TXTWIN_X0
	dec
	sta INDX
	rts
