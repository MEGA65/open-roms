
//
// Sets .X to number of open RS-232 channels
// Sets Carry if more than one is open


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
	
	cpx #$02
	
	rts


#endif
