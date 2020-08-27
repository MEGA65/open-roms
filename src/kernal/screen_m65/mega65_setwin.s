// #LAYOUT# M65 KERNAL_0 #TAKE
// #LAYOUT# *   *        #IGNORE


M65_SETWIN_XY:

	stx M65_TXTWIN_X0
	sty M65_TXTWIN_Y0

	rts


M65_SETWIN_WH:

	pha

	clc
	txa
	adc M65_TXTWIN_X0
	sta M65_TXTWIN_X1

	clc
	tya
	adc M65_TXTWIN_Y0
	sta M65_TXTWIN_Y1

	pla
	rts


M65_SETWIN_N:

	pha

	lda #$00
	sta M65_SCRWINMODE

	jsr m65_screen_set_indx

	pla
	rts


M65_SETWIN_Y:

	pha

	lda #$FF
	sta M65_SCRWINMODE

	jsr m65_screen_set_indx

	// XXX consider calling HOME instead

	lda M65_TXTWIN_X0
	sta M65__TXTCOL

	lda M65_TXTWIN_Y0	
	sta M65__TXTROW

	jsr m65_screen_upd_txtrow_off

	pla
	rts
