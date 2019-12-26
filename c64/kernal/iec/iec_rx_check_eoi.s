
//
// Helper routine to check for EOI while receiving byte from IEC
//

iec_rx_check_eoi:

	// Wait for talker to pull CLK.
	// If over 200 usec (205 cycles on NTSC machine) , then it is EOI.
	// Loop iteraction takes 13 cycles, 17 full iterations are enough

	ldx #$11                           // 2 cycles

!:
	lda CIA2_PRA                       // 4 cycles
	rol                                // 2 cycles, to put CLK in as the last bit
	bpl iec_rx_check_eoi_done          // 2 cycles if not jumped
	dex                                // 2 cycles
    bne !-                             // 3 cycles if jumped
    
	// Timeout - either this is the last byte of stream, or the stream is empty at all.
	// Mark end of stream in IOSTATUS
	jsr kernalstatus_EOI

	// Pull data for 60 usec to confirm it
	jsr iec_release_clk_pull_data
	jsr iec_wait60us
	jsr iec_release_clk_data

iec_rx_check_eoi_done:

	rts
