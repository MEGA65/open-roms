
//
// DolphinDOS protocol support for IEC - byte reception
//


#if CONFIG_IEC_DOLPHINDOS


// XXX experimental, partially copied from standard protocol, not fully tested yet!
// XXX maybe this can be integrated into iec_rx_byte???


iec_rx_byte_dolphindos:

	// Store .X and .Y on the stack - preserve them
	phx_trash_a
	phy_trash_a

	// First, we wait for the talker to release the CLK line
	jsr iec_wait_for_clk_release

	// We then release the DATA to signal we are ready
	// We can use this routine, since we were not pulling CLK anyway
	jsr iec_release_clk_data

	// Wait for talker to pull CLK.
	// If over 200 usec (205 cycles on NTSC machine) , then it is EOI.
	// Loop iteraction takes 13 cycles, 17 full iterations are enough

	ldx #$11                // 2 cycles
iec_rx_dd_clk_wait1:
	lda CIA2_PRA            // 4 cycles
	rol                     // 2 cycles, to put CLK in as the last bit
	bpl iec_rx_dd_not_eoi   // 2 cycles if not jumped
	dex                     // 2 cycles
    bne iec_rx_dd_clk_wait1 // 3 cycles if jumped
    
	// Timeout - either this is the last byte of stream, or the stream is empty at all.
	// Mark end of stream in IOSTATUS
	jsr kernalstatus_EOI

iec_rx_dd_not_empty:

	// Pull data for 60 usec to confirm it
	jsr iec_release_clk_pull_data
	jsr iec_wait60us
	jsr iec_release_clk_data

iec_rx_dd_not_eoi:

	// Retrieve byte via parallel, store it
	lda CIA2_PRB
	sta TBTCNT // $A4 is a byte buffer according to http://sta.c64.org/cbm64mem.html

	// Inform the drive about byte reception
	jsr iec_release_clk_pull_data

	jmp iec_rx_end

#endif
