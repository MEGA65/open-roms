iec_assert_atn:
	lda $dd00
	ora #$08
	sta $dd00
	rts
