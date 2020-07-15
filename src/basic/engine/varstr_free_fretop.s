// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE

//
// Helper routines for 'varstr_free'
//

// XXX change DSCPNT to use standard descriptor format

varstr_FRETOP_up:                    // DSCPNT+2 - bytes to increment FRETO, uses DSCPNT+2

	clc
	lda FRETOP+0
	adc DSCPNT+2
	sta FRETOP+0
	bcc !+
	inc FRETOP+1
!:
	rts
