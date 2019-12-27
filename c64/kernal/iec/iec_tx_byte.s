
// Implemented based on https://www.pagetable.com/?p=1135, https://github.com/mist64/cbmbus_doc

// Expects byte to send in TBTCNT ($A4 is a byte buffer according to http://sta.c64.org/cbm64mem.html)
// Carry flag set = signal EOI
//
// Preserves .X and .Y registers


#if CONFIG_IEC


#if CONFIG_IEC_JIFFYDOS

iec_tx_dispatch:

	php                                // preserve C flag for EOI indication
	lda IECPROTO
	cmp #$01
	bne !+

	plp
	jmp jiffydos_tx_byte
!:
	plp
	
	// FALLTROUGH

#endif // CONFIG_IEC_JIFFYDOS


iec_tx_byte:

	// Store .X and .Y on the stack - preserve them
	phx_trash_a
	phy_trash_a

	// Notify all devices that we are going to send a byte
	// and it is going to be a data byte (released ATN)
	jsr iec_release_atn_clk_data

	// Common part of iec_tx_byte and iec_tx_command
	// Implemented based on https://www.pagetable.com/?p=1135, https://github.com/mist64/cbmbus_doc
	// and http://www.zimmers.net/anonftp/pub/cbm/programming/serial-bus.pdf

iec_tx_common:

	// Timing is critical here - execute on disabled IRQs
	// The best practice would be to do PHP first, but it seems this is not
	// what the original ROM does; furthermore, pushing additional bytes to
	// stack can wreck autostart software loading at $0100
	sei

	// Wait till all receivers are ready, they should all release DATA
	jsr iec_wait_for_data_release

	bcc !+

	// At this point a delay 256 usec or more is considered EOI,
	// receiver should now acknowledge it by pulling data for at least 60 usec
	// Keep the implementation as simple as possible: data should be released now
	// so wait until it is pushed and released again
	
	jsr iec_wait_for_data_pull
	jsr iec_wait_for_data_release
!:
	// Pull CLK back to indicate that DATA is not valid, keep it for 60us
	// We can use this routine as we don't hold DATA anyway (and its state doesn't even matter)

	jsr iec_pull_clk_release_data_oneshot
	jsr iec_wait60us

#if CONFIG_IEC_DOLPHINDOS

	// Check if DolphinDOS was detected
	lda IECPROTO
	cmp #$02
	bne iec_tx_no_dolphindos

	// For DolphinDOS just push the byte to parallel port (set it to output first)
	lda #$FF
	sta CIA2_DDRB
	lda TBTCNT
	sta CIA2_PRB

	// Release CLK to indicate data is now valid (we should not hold DATA nevertheless)
	jsr iec_release_clk_data

	// Finish the flow
	jmp iec_tx_common_finalize

iec_tx_no_dolphindos:

#endif // CONFIG_IEC_DOLPHINDOS

	// Now, we can start transmission of 8 bits of data
	ldx #7

iec_tx_common_sendbit:

#if CONFIG_IEC_JIFFYDOS

	bne !+                             // branch if not sending the last bit
    lda IECPROTO
    beq !+                             // branch if standard protocol

    // JiffyDOS ROM performs detection loop on every command; it seems we have to
    // replicate this behaviour for compatibility with at least 1541 JiffyDOS ROM

    jsr jiffydos_detect
!:
#endif // CONFIG_IEC_JIFFYDOS

	// Is next bit 0 or 1?
	lda TBTCNT
	lsr
	sta TBTCNT
	bcs !+

	// Bit is 0
	jsr iec_release_clk_pull_data
	jmp iec_tx_common_bit_is_sent
!:
	// Bit is 1
	jsr iec_release_clk_data

iec_tx_common_bit_is_sent:

	// Wait 20us, so that device(s) can pick DATA
	jsr iec_wait20us

	// Pull CLK for 20us again, before sending the next bit
	// or performing any other action
	jsr iec_pull_clk_release_data_oneshot
	jsr iec_wait20us

	// More bits to send?
	dex
	bpl iec_tx_common_sendbit

	// FALLTROUGH

iec_tx_common_finalize:

	cli

	// Give devices time to tell if they are busy by pulling DATA
	// They should do it within 1ms
	ldx #$FF
!:
	lda CIA2_PRA
	// BPL here is checking that bit 7 clears,
	// i.e, that the DATA line is pulled by drive
	bpl !+
	dex
	bne !-
	bmi !+
	jmp iec_return_DEVICE_NOT_FOUND
!:
	jmp iec_return_success


#endif // CONFIG_IEC
