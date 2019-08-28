
;;
;; Wait 1 ms (1000 usec) - afterwards can use 'bpl' to check that DATA is pulled
;;
;; On NTSC this means 1023 cycles (slightly less on PAL, but we have to be sure).
;; We can't count on badlines, as the screen might be disabled.
;; Delay here is implemeented using VIC-II raster register. Since one raster is
;; 63 cycles, we need at least 17 full rasters to be 100% sure we wait enough


iec_wait1ms_for_data:
	ldx #18 ; we probably won't start with the beginning of raster
	lda VIC_RASTER
*
	cmp VIC_RASTER
	beq -
	lda VIC_RASTER
	dex
	bne -

	lda CIA2_PRA ; pulled DATA = highest bit 0 = 'plus'
	rts
