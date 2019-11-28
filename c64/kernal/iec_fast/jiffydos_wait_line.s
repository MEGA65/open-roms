
//
// JiffyDOS helper routine to wait for appropriate moment,
// where no badline will interrupt the transmission
//


#if CONFIG_IEC_JIFFYDOS


jiffydos_wait_line:

	lda VIC_SCROLY
	and #$10
	beq jiffydos_wait_line_done        // screen is disabled, no need to watch for badlines

	// Avoid 2 lines before the badline, otherwise VIC will ruin the synchronization
	lda VIC_RASTER
	cmp #$2E
	bcc jiffydos_wait_line_done        // we are safe, border - lot of time till badline
!:
	lda VIC_RASTER                     // carry+ is definitely set here!
	sbc VIC_SCROLY
	and #$07                           // we want 8 lowest bits
	cmp #$06
	bcs !-

jiffydos_wait_line_done:

	rts


#endif // CONFIG_IEC_JIFFYDOS
