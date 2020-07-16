// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE

//
// Releases back memory used by string
//
// Input:
// - DSCPNT+1, DSCPNT+2 - pointer to string
//

// XXX test this routine
// XXX check if this entry point is needed


varstr_free:

	// XXX consider moving size check (DSCPNT+0) here

	// XXX
	// XXX check if string is located above FRETOP, handle case if it is not
	// XXX

	// Quick check - is the string the lowest one?

	cmp FRETOP+0
	bne varstr_free_inside
	lda DSCPNT+2
	cmp FRETOP+1
	bne varstr_free_inside

	// This is the lowest string - so just increase FRETOP, this way
	// the garbage collector will not be needed that quickly

	jsr varstr_FRETOP_up                         // free the string data

#if !HAS_OPCODES_65CE02

	lda #$02                                     // free the back-pointer
	sta DSCPNT+0
	jmp varstr_FRETOP_up

#else // HAS_OPCODES_65CE02

	inw FRETOP                                   // free the back-pointer
	inw FRETOP

	rts

#endif

varstr_free_inside:

	// This is not the lowest string; mark it as free
	// First preserve the string size, it will make it easier for the garbage collector

	lda DSCPNT+0
	tay
	dey

#if CONFIG_MEMORY_MODEL_60K
	ldx #<FRETOP
	jsr poke_under_roms
#else // CONFIG_MEMORY_MODEL_38K || CONFIG_MEMORY_MODEL_46K || CONFIG_MEMORY_MODEL_50K
	sta (FRETOP), y
#endif

	// Now increase DSCPNT+1/+2 to point to the back-pointer

	clc
	lda DSCPNT+1
	adc DSCPNT+0
	sta DSCPNT+1
	bcc !+
	inc DSCPNT+2
!:
	// Fill the back-pointer with 0

	lda #$00
	ldy #$00

#if CONFIG_MEMORY_MODEL_60K
	ldx #<DSCPNT+1
	jsr poke_under_roms
#else // CONFIG_MEMORY_MODEL_38K || CONFIG_MEMORY_MODEL_46K || CONFIG_MEMORY_MODEL_50K
	sta (DSCPNT+1), y
#endif

	iny                                          // $00 -> $01

#if CONFIG_MEMORY_MODEL_60K
	jmp poke_under_roms
#else // CONFIG_MEMORY_MODEL_38K || CONFIG_MEMORY_MODEL_46K || CONFIG_MEMORY_MODEL_50K
	sta (DSCPNT+1), y
	rts
#endif
