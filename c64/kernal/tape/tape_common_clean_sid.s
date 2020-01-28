// #LAYOUT# STD *        #TAKE
// #LAYOUT# M65 KERNAL_1 #TAKE
// #LAYOUT# *   *        #IGNORE

//
// Clear the SID settings - for sound effects during LOAD
//


#if CONFIG_TAPE_TURBO


tape_clean_sid:

	lda #$00
	ldy #$1C
!:
	sta __SID_BASE, y
	dey
	bpl !-

	rts


#endif
