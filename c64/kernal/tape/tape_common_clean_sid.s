#if ROM_LAYOUT_STD || (ROM_LAYOUT_M65 && SEGMENT_KERNAL_0)

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


#endif // ROM layout
