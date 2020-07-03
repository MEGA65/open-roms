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

	// This is the lowest string - so just increase FRETOP, this way
	// the garbage collector will not be needed that quickly

	jsr varstr_FRETOP_up                         // free the string data

#if !HAS_OPCODES_65CE02

	lda #$02                                     // free the back-pointer
	sta DSCPNT+2
	jmp varstr_FRETOP_up

#else // HAS_OPCODES_65CE02

	inw FRETOP                                   // free the back-pointer
	inw FRETOP

	rts

#endif

varstr_free_inside:

	// This is not the lowest string; mark it as free
	// First preserve the string size, it will make it easier for the garbage collector

	lda DSCPNT+2
	tay
	dey

#if CONFIG_MEMORY_MODEL_60K
	ldx #<FRETOP
	jsr poke_under_roms
#else // CONFIG_MEMORY_MODEL_38K || CONFIG_MEMORY_MODEL_46K || CONFIG_MEMORY_MODEL_50K
	sta (FRETOP), y
#endif

	// Now increase DSCPNT+0/+1 to point to the back-pointer

	clc
	lda DSCPNT+0
	adc DSCPNT+2
	sta DSCPNT+0
	bcc !+
	inc DSCPNT+1
!:
	// Fill the back-pointer with 0

	lda #$00
	ldy #$00

#if CONFIG_MEMORY_MODEL_60K
	ldx #<DSCPNT
	jsr poke_under_roms
#else // CONFIG_MEMORY_MODEL_38K || CONFIG_MEMORY_MODEL_46K || CONFIG_MEMORY_MODEL_50K
	sta (DSCPNT), y
#endif

	iny                                          // $00 -> $01

#if CONFIG_MEMORY_MODEL_60K
	jmp poke_under_roms
#else // CONFIG_MEMORY_MODEL_38K || CONFIG_MEMORY_MODEL_46K || CONFIG_MEMORY_MODEL_50K
	sta (DSCPNT), y
	rts
#endif
