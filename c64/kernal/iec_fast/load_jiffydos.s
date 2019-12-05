
//
// JiffyDOS protocol support for IEC - optimized load loop
//


#if CONFIG_IEC_JIFFYDOS && !CONFIG_MEMORY_MODEL_60K


// Note: original JiffyDOS LOAD loop checks for RUN/STOP key every time a sector is read.
// For simplicity and some space savings, our routine does not check the RUN/STOP key at all;
// the protocol is fast enough (especiallyy with modern flash mediums) that probably nobody
// will want to terminate the loading.


load_jiffydos:

	// Timing is critical, do not allow interrupts
	sei

	// Store previous sprite status in temporary variable
	jsr jiffydos_prepare
	sta TBTCNT

	// A trick to shorten EAL update time
	ldy #$FF

	// FALLTROUGH

load_jiffydos_loop:

	// Wait until device is ready to send
	jsr iec_wait_for_clk_release

	// Prepare 'start sending' message
	lda CIA2_PRA
	and #$FF - BIT_CIA2_PRA_DAT_OUT    // release
	tax

	// Wait for appropriate moment
	jsr jiffydos_wait_line // XXX try to inline this, maybe one raster is enough?

	// Ask device to start sending bits
	stx CIA2_PRA                       // cycles: 4

	// Prepare 'data pull' byte, cycles: 3 + 2 + 2 = 7
	lda C3PO
	ora #BIT_CIA2_PRA_DAT_OUT          // pull
	tax

	// Delay, JiffyDOS needs some time, 4 cycles
	nop
	nop

	// Get bits, cycles: 4 + 2 + 2 = 8
	lda CIA2_PRA                       // bits 0 and 1 on CLK/DATA
	lsr
	lsr

	// Wait for the drive - we have time to increment offset, cycles: 2
	iny

	// Get bits, cycles: 4 + 2 + 2 = 8
	ora CIA2_PRA                       // bits 2 and 3 on CLK/DATA
	lsr
	lsr

	// Get bits, cycles: 3 + 4 + 2 + 2 = 11
	eor C3PO
	eor CIA2_PRA                       // bits 4 and 5 on CLK/DATA
	lsr
	lsr

	// Get bits, cycles: 3 + 4 = 7
	eor C3PO
	eor CIA2_PRA                       // bits 6 and 7 on CLK/DATA

	// Store retrieved byte, cycles: 6 
	sta (EAL),y                        // not compatible with CONFIG_MEMORY_MODEL_60K

	// Retrieve status bits, cycles: 4
	bit CIA2_PRA

	// Pull DATA at the end, cycles: 4
	stx CIA2_PRA

	// If CLK line not active - this was the last byte
	bvs load_jiffydos_end

	// Handle EAL
	cpy #$FF
	bne load_jiffydos_loop
	inc EAL+1
	jmp load_jiffydos_loop

load_jiffydos_end:

	// Save last byte
	tax

	// Update EAL
	tya
	sec
	adc EAL+0
	sta EAL+0
	bcc !+
	inc EAL+1
!:
	// Indicate that no byte waits in output buffer
	lda #$00
	sta C3PO

	// Restore proper IECPROTO value
	lda #$01
	sta IECPROTO

	// Re-enable sprites
	lda TBTCNT
	sta VIC_SPENA

	// Store last byte as unoptimized LOAD routine would
	stx TBTCNT

	// End of load loop
	jmp load_iec_loop_end


#endif // CONFIG_IEC_JIFFYDOS and not CONFIG_MEMORY_MODEL_60K
