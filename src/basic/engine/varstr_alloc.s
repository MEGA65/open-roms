// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE

//
// Allocates memory for string - lowers FRETOP (but not below STREND)
//
// Note: We are not going to use the C64-style memory management here, as it implies
// a very slow garbage collector. Instead, we are using a scheme similar to used in
// BASIC V3.5 and later, with 'back-pointers' after each string, telling about the
// location of the string descriptor. 
//
// See:
// - https://www.c64-wiki.com/wiki/Memory_(BASIC)
// - https://sites.google.com/site/h2obsession/CBM/basic/variable-format
//
// Input:
// - DSCPNT+0, DSCPNT+1 - pointer to string descriptor, first pointed byte should contain desired length
//

varstr_alloc:

	// Mark garbage collector as not run yet

	lda #$00

	// FALLTROUGH

varstr_alloc_retry:

	sta GARBFL                                   // Computes Mapping the Commodore 64, page 10

	// Backup FRETOP in case of alocation problems

	lda FRETOP+0
	sta INDEX+0
	lda FRETOP+1
	sta INDEX+1

	// Lower FRETOP to make space for string descriptor

#if !HAS_OPCODES_65CE02

	lda #$02
	jsr varstr_FRETOP_down 

#else // HAS_OPCODES_65CE02

	dew FRETOP
	dew FRETOP

#endif

	jsr varstr_FRETOP_check
	bcs varstr_alloc_fail

	// XXX finish this





varstr_alloc_fail:

	// Unable to alocate memory - restore FRETOP value

	lda INDEX+0
	sta FRETOP+0
	lda INDEX+1
	sta FRETOP+1

	// Check if it is worth to perform garbage collection and retry

	bit GARBFL

	// XXX finish this




// XXX move these helper routines to a better place


varstr_FRETOP_down: // memmove__tmp - length to lower FRETOP

	sec
	lda FRETOP+0
	sbc memmove__tmp
	sta FRETOP+0
	bcs !+
	dec FRETOP+1
!:
	rts

varstr_FRETOP_check:

	// Check if FRETOP > STREND, Carry set if not

	lda STREND+1
	cmp FRETOP+1
	beq !+
	rts
!:
	lda STREND+0
	cmp FRETOP+0
	rts
