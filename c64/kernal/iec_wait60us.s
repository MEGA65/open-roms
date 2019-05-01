iec_wait60us:	

	;; Waste ~60 clock cycles (including JSR + RTS)
	ldy #$06
*	lda $dd00
	dey
	bpl -

	rts
