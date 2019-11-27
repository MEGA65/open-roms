
//
// JiffyDOS protocol support for IEC
//

// XXX finish this



#if CONFIG_IEC_JIFFYDOS


// JiffyDOS timing regime is very strict - before transmitting anything
// we need to disable sprites and (if screen is not disabled) wait for
// appropriate moment, so that no badline interruption can happen


iec_tx_byte_jiffydos:

	// Timing is critical, do not allow interrupts
	sei

	// Preserve .X (.Y is not used by the routine)
	phx_trash_a

	// If EOI requested (carry flag set), mark this in IECPROTO as 0
	bcc !+
	dec IECPROTO                       // turns 1 into 0
!:
	// We need to preserve 3 lowest bits of CIA2_PRA, they contain important
	// data - fortunately, the bits are never changed by external devices
	// Use C3PO for this, as afterwards we have to set there 0 nevertheless
	lda CIA2_PRA
	and #%00000111
	sta C3PO

	// Hide sprites, store their previous status on stack
	jsr jiffydos_hide_sprites // XXX include C3PO initialization
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

	// Prepare value for device notification
	ldx C3PO

	// Wait till receiver is ready
	jsr iec_wait_for_data_release

__jd_check1:

	// Wait till it is safe to send data
	jsr jiffydos_wait_line

	// Notify device that we are going to send byte by releasing everything
	stx CIA2_PRA                       // cycles: 4

	// Send high nibble; cycles: 4 + 3 + 4 + 2 + 2 + 2 + 3 + 4 = 24
	pla                                // retrieve high nibble from stack
	ora C3PO                           // restore VIC-II and RS-232 bits
	sta CIA2_PRA                       // bits 4 and 5 on CLK/DATA
	ror                                // move bits 6 and 7 to positions 4 and 5
	ror
	and #%00110000                     // clear everything but CLK/DATA
	ora C3PO
	sta CIA2_PRA                       // bits 6 and 7 on CLK/DATA

	// Send low nibble; cycles: 4 + 3 + 4 + 2 + 2 + 2 + 4 = 21
	pla                                // retrieve low nibble from stack
	ora C3PO                           // restore VIC-II and RS-232 bits
	sta CIA2_PRA
	lsr
	lsr
	and #%00110000                     // clear everything but CLK/DATA
	sta CIA2_PRA

	// Signal EOI if needed; cycles till no EOI: 3 + 3 + 2 + 2 + 4 = 14 
	lda C3PO
	ldx IECPROTO
	beq iec_tx_byte_jiffydos_wait_eoi

	// FALLTROUGH

iec_tx_byte_jiffydos_finalize:

	ora #BIT_CIA2_PRA_CLK_OUT          // pull CLK
	sta CIA2_PRA

	// XXX part below should be common for TX and RX

	// Re-enable sprites
	pla
	sta VIC_SPENA

	// Mark TX buffer as empty, restore proper IECPROTO value
	ldx #$00
	stx C3PO
	inx
	sta IECPROTO

	// Restore .X, interrupts, return
	plx_trash_a
	cli
	rts

iec_tx_byte_jiffydos_wait_eoi:

	jsr iec_wait60us
	lda C3PO
	jmp iec_tx_byte_jiffydos_finalize



iec_rx_byte_jiffydos:

	// Timing is critical, do not allow interrupts
	sei

	// Preserve .X (.Y is not used by the routine)
	phx_trash_a

	// We need to preserve 3 lowest bits of CIA2_PRA, they contain important
	// data - fortunately, the bits are never changed by external devices
	// Use C3PO for this, as afterwards we have to set there 0 nevertheless
	lda CIA2_PRA
	and #%00000111
	sta C3PO

	// Hide sprites, store their previous status on stack
	jsr jiffydos_hide_sprites
	pha

	// Wait until device is ready to send
	jsr iec_wait_for_clk_release

	// Prepare 'start sending' message
	lda CIA2_PRA
	and #$FF - BIT_CIA2_PRA_DAT_OUT    // release
	tax

	// Wait for appropriate moment
	jsr jiffydos_wait_line

	// Ask device to start sending bits
	stx CIA2_PRA                       // cycles: 4

	// Retrieve byte XXX count cycles, synchronize

	lda CIA2_PRA                       // bits 0 and 1 on CLK/DATA
	lsr
	lsr

	ora CIA2_PRA                       // bits 2 and 3 on CLK/DATA
	lsr
	lsr

	eor C3PO
	eor CIA2_PRA                       // bits 4 and 5 on CLK/DATA
	lsr
	lsr

	eor C3PO
	eor CIA2_PRA                       // bits 6 and 7 on CLK/DATA
	tax

	// XXX CLK and DATA active = EOI
	lda CIA2_PRA



	// Re-enable sprites
	pla
	sta VIC_SPENA

	// Restore .X, interrupts, return
	plx_trash_a
	cli
	rts


jiffydos_wait_line:

	lda VIC_SCROLY
	and #$10
	beq jiffydos_wait_line_done        // screen is disabled, no need to watch for badlines

	// To give the transfer routine as much time as possible,
	// wait till a badline

	// XXX probably overkill, most likely it is enough to avoid 2 lines before badline
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
