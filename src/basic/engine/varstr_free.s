// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE

//
// Releases back memory used by string
//
// Input:
// - DSCPNT+0, DSCPNT+1 - pointer to string descriptor
//

// XXX test this routine

varstr_free:

	// First copy the string descriptor data to DSCPNT
	// XXX write optimized version for CONFIG_MEMORY_MODEL_46K || CONFIG_MEMORY_MODEL_50K

	ldy #$00

#if CONFIG_MEMORY_MODEL_60K
	ldx #<DSCPNT
	jsr peek_under_roms
#elif CONFIG_MEMORY_MODEL_46K || CONFIG_MEMORY_MODEL_50K
	jsr peek_under_roms_via_DSCPNT
#else // CONFIG_MEMORY_MODEL_38K
	lda (DSCPNT),y
#endif

	sta DSCPNT+2                                 // length of the string
	iny

#if CONFIG_MEMORY_MODEL_60K
	jsr peek_under_roms
#elif CONFIG_MEMORY_MODEL_46K || CONFIG_MEMORY_MODEL_50K
	jsr peek_under_roms_via_DSCPNT
#else // CONFIG_MEMORY_MODEL_38K
	lda (DSCPNT),y
#endif

	pha
	iny

#if CONFIG_MEMORY_MODEL_60K
	jsr peek_under_roms
#elif CONFIG_MEMORY_MODEL_46K || CONFIG_MEMORY_MODEL_50K
	jsr peek_under_roms_via_DSCPNT
#else // CONFIG_MEMORY_MODEL_38K
	lda (DSCPNT),y
#endif

	sta DSCPNT+1
	pla
	sta DSCPNT+0

	// Quick check - is the string the lowest one?

	cmp FRETOP+0
	bne varstr_free_inside
	lda DSCPNT+1
	cmp FRETOP+1
	bne varstr_free_inside

	// This is the lowest string - increase FRETOP, this way
	// the garbage collector will not be needed that quickly

	// XXX implement this

varstr_free_inside:

	// THis is not the lowest string; mark it as free

	// XXX implement this

	rts
