iec_assert_data:
	lda $dd00
	ora #$20
	sta $dd00
	rts
