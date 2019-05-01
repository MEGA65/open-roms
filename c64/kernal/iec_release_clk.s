iec_release_clk:
	lda $dd00
	and #$18
	sta $dd00
	rts
