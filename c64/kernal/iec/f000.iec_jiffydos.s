
//
// JiffyDOS protocol support for IEC
//

// XXX finish this



#if CONFIG_IEC_JIFFYDOS


// JiffyDOS timing regime is very strict - before transmitting anything
// we need to disable sprites and (if screen is not disabled) wait for
// appropriate moment, so that no badline interruption can happen


iec_tx_byte_jiffydos:

	// We need to preserve 3 lowest bits of CIA2_PRA - as they encode
	// Use C3PO for this, as afterwards we have to set there 0 nevertheless
	lda CIA2_PRA
	and #%00000111
	sta C3PO

	// Hide sprites, store their previous status on stack
	jsr jiffydos_hide_sprites
	pha

	// Prepare nibbles to send
	lda TBTCNT
	and #$0F
	tax
	lda iec_jiffydos_bittable, X       // low nibble has to be encoded
	pha
	lda TBTCNT
	and #$F0
	pha

	// Wait till receiver is ready
	jsr iec_wait_for_data_release

__jd_check1:

	// Wait till it is safe to send data
	jsr jiffydos_wait_line

	// Notify device that we are going to send byte by releasing everything
	// Cycles: 3 + 4 = 7
	lda C3PO
	sta CIA2_PRA

	// Send high nibble; cycles: 4 + 3 + 4 + 2 + 2 + 2 + 4 = 21
	pla                                // retrieve high nibble from stack
	ora C3PO                           // restore VIC-II and RS-232 bits
	sta CIA2_PRA                       // bits 4 and 5 on CLK/DATA
	ror                                // move bits 6 and 7 to positions 4 and 5
	ror
	and #%00110000                     // clear everything but CLK/DATA
	sta CIA2_PRA                       // bits 6 and 7 on CLK/DATA

	// Send low nibble; cycles: 4 + 3 + 4 + 2 + 2 + 2 + 4 = 21
	pla                                // retrieve low nibble from stack
	ora C3PO                           // restore VIC-II and RS-232 bits
	sta CIA2_PRA
	ror
	ror
	and #%00110000                     // clear everything but CLK/DATA
	sta CIA2_PRA



	// XXX EOI signalled by early CLK (20us delay for non-CLK?)


	// Re-enable sprites
	pla
	lda VIC_SPENA

	// Mark TX buffer as empty
	lda #$00
	sta C3PO

	rts


iec_rx_byte_jiffydos:

	// Hide sprites, store their previous status on stack
	jsr jiffydos_hide_sprites
	pha

	// Wait until device is ready to send
	jsr iec_wait_for_clk_release

	// Prepare 'start sending' message
	lda CIA2_PRA
	and #$FF - BIT_CIA2_PRA_DAT_OUT    // release
	pha

	// Wait for appropriate moment
	jsr jiffydos_wait_line

	// Ask device to start sending bits
	pla
	sta CIA2_PRA


	// XXX retrieve byte


	// Re-enable sprites
	pla
	lda VIC_SPENA

	rts


jiffydos_wait_line:

	lda VIC_SCROLY
	and #$10
	beq jiffydos_wait_line_done        // screen is disabled, no need to watch for badlines

	// To give the transfer routine as much time as possible,
	// wait till a badline

	// XXX this is probably overkill, most likely it is enough to avoid 2 (3?) lines
	//     before badline - to be adjusted in the future
!:
	sec
	lda VIC_SCROLY
	sbc VIC_RASTER
	and #$07                           // we want 8 lowest bits
	bne !-

jiffydos_wait_line_done:
	rts


__jd_check2:


jiffydos_hide_sprites:

	lda VIC_SPENA
	ldx #$00
	stx VIC_SPENA

	rts


.function SAME_PAGE_CHECK(label_1, label_2)
{
#if PASS_SIZETEST
	.return (label_1 - label_1 % 256) == (label_2 - label_2 % 256)
#else
	.return true
#endif
}

.if (!SAME_PAGE_CHECK(__jd_check1, __jd_check2))
{
	// To meet the strict JiffyDOS timing, we need to make sure
	// it does not span across multiple pages, as this would add
	// 1 cycle to some jump instructions - maybe this wont cause
	// problems, but better safe than sorry.

	.error "JiffyDOS code can't span across multiple pages"
}


#endif // CONFIG_IEC_JIFFYDOS
