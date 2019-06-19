iec_wait60us:	

	;; Waste ~60 clock cycles (including JSR + RTS)
	ldy #$06
*	lda $dd01 ; reading dd00 makes debugging harder
	dey
	bpl -

	rts
