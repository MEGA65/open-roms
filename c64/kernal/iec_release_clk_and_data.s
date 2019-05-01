iec_release_clk_and_data:	

	lda $DD00
	and #$08
	sta $DD00
	rts
