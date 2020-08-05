// #LAYOUT# STD *        #TAKE
// #LAYOUT# *   KERNAL_0 #TAKE
// #LAYOUT# *   *        #IGNORE

//
// Sets .X to number of open RS-232 channels
//


#if HAS_RS232


rs232_count_channels:

	ldx #$00
	ldy LDTND
!:
	dey
	bmi !+
	lda FAT, y
	cmp #$02
	bne !-
	inx
	bpl !- // branch always
!:
	rts


#endif
