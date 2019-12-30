

screen_add_40_to_PNTR:
	
	lda PNTR
	clc
	adc #40
	sta PNTR

	rts
