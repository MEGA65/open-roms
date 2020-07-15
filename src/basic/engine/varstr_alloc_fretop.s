// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE

//
// Helper routines for 'varstr_alloc'
//

// XXX change DSCPNT to use standard descriptor format

varstr_FRETOP_down_A:                  // .A - bytes to lower FRETOP, uses DSCPNT+2

	sta DSCPNT+2 

	sec
	lda FRETOP+0
	sbc DSCPNT+2 
	sta FRETOP+0
	bcs !+
	dec FRETOP+1
!:
	// FALLTROUGH

varstr_FRETOP_check:                   // check if FRETOP > STREND, Carry set if not

	lda STREND+1
	cmp FRETOP+1
	beq !+
	rts
!:
	lda STREND+0
	cmp FRETOP+0
	rts
