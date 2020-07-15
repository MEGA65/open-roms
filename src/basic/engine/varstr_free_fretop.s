// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE

//
// Helper routines for 'varstr_free'
//

// XXX change DSCPNT to use standard descriptor format

varstr_FRETOP_up:                    // DSCPNT+0 - bytes to increment FRETO

	clc
	lda FRETOP+0
	adc DSCPNT+0
	sta FRETOP+0
	bcc !+
	inc FRETOP+1
!:
	rts
