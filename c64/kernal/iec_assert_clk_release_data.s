iec_assert_clk_release_data:
	lda $dd00
	and #$08
	ora #$10
	sta $dd00
	rts
