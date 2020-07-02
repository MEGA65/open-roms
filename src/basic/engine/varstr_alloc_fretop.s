// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE

//
// Helper routines for 'varstr_alloc'
//

varstr_FRETOP_down:                    // .A - bytes to lower FRETOP, uses memmove__tmp

	sta memmove__tmp

	sec
	lda FRETOP+0
	sbc memmove__tmp
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
