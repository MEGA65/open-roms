iec_release_clk_and_data:	

	lda $DD00
	and #$0b
	sta $DD00
	rts
