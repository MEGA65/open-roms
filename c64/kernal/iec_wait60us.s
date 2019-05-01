iec_wait60us:	

	;; Waste ~60 clock cycles (including JSR + RTS)
	ldx #$06
*	lda $dd00
	dex
	bpl -

	rts
