// #LAYOUT# STD *        #TAKE
// #LAYOUT# *   KERNAL_0 #TAKE
// #LAYOUT# *   *        #IGNORE

//
// JiffyDOS protocol support for IEC - byte transfer
//


#if CONFIG_IEC_JIFFYDOS


jiffydos_tx_byte:

	// Timing is critical, do not allow interrupts
	sei

	// If EOI requested (carry flag set), mark this in IECPROTO as 0
	bcc !+
	dec IECPROTO                       // turns 1 into 0
!:
	// Store .X and .Y on the stack - preserve them
	phx_trash_a
	phy_trash_a

	// Make sure we are not sending data on ATN
	jsr iec_release_atn

	// Store previous sprite status on stack
	jsr jiffydos_prepare
	pha

	// Prepare nibbles to send
	lda TBTCNT
	and #$0F
	tax
	lda jiffydos_bittable, X           // low nibble has to be encoded
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
	beq jiffydos_tx_byte_wait_eoi

	// FALLTROUGH

jiffydos_tx_byte_finalize:

	ora #BIT_CIA2_PRA_CLK_OUT          // pull CLK
	sta CIA2_PRA

	// Restore proper IECPROTO value
	lda #$01
	sta IECPROTO

	// Re-enable sprites and interrupts
	pla
	sta VIC_SPENA
	cli

	// Return success
	jmp iec_return_success


jiffydos_tx_byte_wait_eoi:

	sta CIA2_PRA
	jsr iec_wait20us
	lda C3PO
	jmp jiffydos_tx_byte_finalize


#endif // CONFIG_IEC_JIFFYDOS
