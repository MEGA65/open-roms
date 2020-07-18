// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE

//
// Releases back memory used by string
//
// Input:
// - DSCPNT+0           - string size
// - DSCPNT+1, DSCPNT+2 - pointer to string
//


varstr_free:

	// Check the string size - do not do anything if 0

	lda DSCPNT+0
	bne !+
	rts
!:
	// Check if string is above FRETOP (in string area)

	jsr varstr_cmp_fretop
	bcs !+

	// No, it does not belong to string area - quit

	rts
!:
	// Check if this is the lowest string

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

	// Increase DSCPNT+1/+2 to point to the back-pointer minus 1

	dec DSCPNT+0

	clc
	lda DSCPNT+1
	adc DSCPNT+0
	sta DSCPNT+1
	bcc !+
	inc DSCPNT+2
!:
	// Put the size-1, garbage collector will make use of this value

	lda DSCPNT+0
	ldy #$00

#if CONFIG_MEMORY_MODEL_60K
	ldx #<DSCPNT+1
	jsr poke_under_roms
#else // CONFIG_MEMORY_MODEL_38K || CONFIG_MEMORY_MODEL_46K || CONFIG_MEMORY_MODEL_50K
	sta (DSCPNT+1), y
#endif

	// Now fill-in the back-pointer with 0's

	tya
	iny

#if CONFIG_MEMORY_MODEL_60K
	jsr poke_under_roms
#else // CONFIG_MEMORY_MODEL_38K || CONFIG_MEMORY_MODEL_46K || CONFIG_MEMORY_MODEL_50K
	sta (DSCPNT+1), y
#endif

	iny

#if CONFIG_MEMORY_MODEL_60K
	jmp poke_under_roms
#else // CONFIG_MEMORY_MODEL_38K || CONFIG_MEMORY_MODEL_46K || CONFIG_MEMORY_MODEL_50K
	sta (DSCPNT+1), y
	rts
#endif
