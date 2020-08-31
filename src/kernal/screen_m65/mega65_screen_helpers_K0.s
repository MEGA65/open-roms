// #LAYOUT# M65 KERNAL_0 #TAKE
// #LAYOUT# *   *        #IGNORE

//
// Set the INDX variable - logical row length
//

m65_screen_set_indx: // leaves value in .A

    lda M65_SCRWINMODE
    bmi !+

    // Non-windowed mode

    phx
	ldx M65_SCRMODE
	lda m65_scrtab_txtwidth,x
	dec_a
	sta INDX
	plx
	rts
!:
	// Windowed mode

	sec
	lda M65_TXTWIN_X1
	sbc M65_TXTWIN_X0
	dec_a
	sta INDX
	rts
