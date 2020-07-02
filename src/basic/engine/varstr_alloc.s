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

// XXX test this routine

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

#else // HAS_OPCODES_65CE02 - this time code is slightly longer, but faster

	dew FRETOP
	dew FRETOP

	jsr varstr_FRETOP_check

#endif

	bcs varstr_alloc_fail

	// Create the back-pointer to the string descriptor

	ldy #$00
	lda DSCPNT+0
	sta (FRETOP), y
	iny
	lda DSCPNT+1
	sta (FRETOP), y

	// Now lower FRETOP again to make space for the string content

	dey                                          // $01 -> $00
	lda (DSCPNT), y
	jsr varstr_FRETOP_down
	bcs varstr_alloc_fail

	// Success - fill in the string descriptor

	iny                                          // $00 -> $01
	lda FRETOP+0
	sta (DSCPNT), y
	iny
	lda FRETOP+1
	sta (DSCPNT), y

	// The end

	rts

varstr_alloc_fail:

	// Unable to alocate memory - restore FRETOP value

	lda INDEX+0
	sta FRETOP+0
	lda INDEX+1
	sta FRETOP+1

	// Check if it is worth to perform garbage collection and retry

	bit GARBFL
	bpl_16 do_OUT_OF_MEMORY_error

	dec GARBFL                                   // $00 -> $FF
	jsr varstr_garbage_collect

#if HAS_OPCODES_65C02
	bra varstr_alloc_retry
#else
	jmp varstr_alloc_retry
#endif
