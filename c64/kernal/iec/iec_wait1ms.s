
//
// Wait 1 ms (1000 usec)
//
// On NTSC this means 1023 cycles (slightly less on PAL, but we have to be sure).
// We can't count on badlines, as the screen might be disabled.
// Delay here is implemented using VIC-II raster register. Since one raster is
// 63 cycles, we need at least 17 full rasters to be 100% sure we wait enough


#if CONFIG_IEC


iec_wait1ms:

	ldx #18 // we probably won't start with the beginning of raster

#endif // CONFIG_IEC

wait_x_bars: // additional entry point for delayy in screen and tape support
             // has to preserve .Y and put .X to 0

	lda VIC_RASTER
!:
	cmp VIC_RASTER
	beq !-
	lda VIC_RASTER
	dex
	bne !-

iec_wait_rts: // dummy RTS, for very short waits

	rts
