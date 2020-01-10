#if ROM_LAYOUT_STD || (ROM_LAYOUT_M65 && SEGMENT_KERNAL_0)

//
// Sets .X to number of open RS-232 channels
//


#if HAS_RS232


rs232_count_channels:

	ldx #$00
	ldy LDTND
!:
	dey
	bmi close_rs232_search_done
	lda FAT, y
	cmp #$02
	bne !-
	inx
	bpl !- // branch always
	
	rts


#endif


#endif // ROM layout
