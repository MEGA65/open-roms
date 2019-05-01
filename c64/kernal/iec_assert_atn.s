iec_assert_atn:
	lda $dd0d
	ora #$08
	sta $dd0d
	rts
