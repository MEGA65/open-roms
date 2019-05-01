iec_release_clk:
	lda $dd00
	and #$2b
	sta $dd00
	rts
