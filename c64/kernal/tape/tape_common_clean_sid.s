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

#if CONFIG_MB_MEGA_65

	// It should be safer than cleaning whole $D400-D47C range

	sta __SID_BASE + __SID_R1_OFFSET, y
	sta __SID_BASE + __SID_R2_OFFSET, y
	sta __SID_BASE + __SID_L1_OFFSET, y
	sta __SID_BASE + __SID_L2_OFFSET, y

#else

	sta __SID_BASE, y

#endif

	dey
	bpl !-

	rts


#endif
