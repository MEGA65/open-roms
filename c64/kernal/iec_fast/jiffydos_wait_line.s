
//
// JiffyDOS helper routine to wait for appropriate moment,
// where no badline will interrupt the transmission
//


#if CONFIG_IEC_JIFFYDOS


jiffydos_wait_line:

	// One might try to optimize the code by checking for disabled screen
	// (bit 4 of VIC_SCROLY); problem: VIC checks this bit only once per frame:
	// - https://www.lemon64.com/forum/viewtopic.php?t=56582
	// so it would complicated the code

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
