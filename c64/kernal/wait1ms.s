	;; 16 rasters = 16 x 63 cycles = ~1ms
	;; (Probably 2 will be bad lines, so we will over-estimate the delay a bit)
	
wait1ms:
	ldx #16
	lda $d012
*
	cmp $d012
	beq -
	lda $d012
	dex
	bne -
	rts
	
