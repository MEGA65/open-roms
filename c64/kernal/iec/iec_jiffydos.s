
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

	// If EOI requested (carry flag set), mark this in IECPROTO as 0
	bcc !+
	dec IECPROTO                       // turns 1 into 0
!:
	// Store .X and .Y on the stack - preserve them
	phx_trash_a
	phy_trash_a

	// Store previous sprite status on stack
	jsr jiffydos_prepare_for_transfer
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

	// Wait till it is safe to send data
	jsr jiffydos_wait_line

	// Notify device that we are going to send byte by releasing everything
	stx CIA2_PRA                       // cycles: 4

	// Send high nibble; cycles: 4 + 3 + 4 + 2 + 2 + 2 + 3 + 4 = 24
	pla                                // retrieve high nibble from stack
	ora C3PO                           // restore VIC-II and RS-232 bits
	sta CIA2_PRA                       // bits 4 and 5 on CLK/DATA
	lsr                                // move bits 6 and 7 to positions 4 and 5
	lsr
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

	bne jiffydos_return_success        // branch always

iec_tx_byte_jiffydos_wait_eoi:

	jsr iec_wait20us // XXX is it enough?
	lda C3PO
	jmp iec_tx_byte_jiffydos_finalize



iec_rx_byte_jiffydos:

	// Timing is critical, do not allow interrupts
	sei

	// Store .X and .Y on the stack - preserve them
	phx_trash_a
	phy_trash_a

	// Store previous sprite status on stack
	jsr jiffydos_prepare_for_transfer
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


	// FALLTROUGH

jiffydos_return_success:

	// Restore proper IECPROTO value
	lda #$01
	sta IECPROTO

	// Re-enable sprites and interrupts
	pla
	sta VIC_SPENA
	cli

	// Return success
	jmp iec_return_success


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


jiffydos_prepare_for_transfer:

	// We need to preserve 3 lowest bits of CIA2_PRA, they contain important
	// data - fortunately, the bits are never changed by external devices
	// Use C3PO for this, as afterwards we have to set there 0 nevertheless
	lda CIA2_PRA
	and #%00000111
	sta C3PO

	// Hide sprites
	lda VIC_SPENA
	ldx #$00
	stx VIC_SPENA

	rts


#endif // CONFIG_IEC_JIFFYDOS
