iec_assert_clk_and_data:
	lda $dd00
	and #$0b
	ora #$30
	sta $dd00
	rts
