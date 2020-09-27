


sdcard_wait_16000_usec:

	; Uses VIC-II raster register; wait time is not exactly precise, but should be
	; a good approximation

	phx
	pha

	ldx #$FF

	; XXX wait below is same as in KKERNAL, wait_x_lines - consider importing and reusing
	lda VIC_RASTER
@1:
	cmp VIC_RASTER
	beq @1
	lda VIC_RASTER
	dex
	bne @1

	pla
	plx

	rts
