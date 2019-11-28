
//
// JiffyDOS protocol support for IEC - byte reception
//


#if CONFIG_IEC_JIFFYDOS


iec_rx_byte_jiffydos:

	// Timing is critical, do not allow interrupts
	sei

	// Store .X and .Y on the stack - preserve them
	phx_trash_a
	phy_trash_a

	// Store previous sprite status on stack
	jsr jiffydos_prepare
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

	// XXX we have to wait 20 cycles??? seriously??? what the hell shall we do here???
	pla // 4 cycles
	pha // 3 cycles
	pla // 4 cycles
	pha // 3 cycles
	nop // 2 cycles
	nop // 2 cycles
	nop // 2 cycles

	// Get bits, cycles: 4 + 2 + 2 = 8
	lda CIA2_PRA                       // bits 0 and 1 on CLK/DATA
	lsr
	lsr

	// Wait for the drive, cycles: 2
	nop

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

	// Preserve read byte
	sta TBTCNT // $A4 is a byte buffer according to http://sta.c64.org/cbm64mem.html

	// Retrieve status bits
	lda CIA2_PRA
	tax

	// Pull DATA at the end
	ora #BIT_CIA2_PRA_DAT_OUT
	sta CIA2_PRA

	// Check for EOI
	txa
	bmi !+
	jsr kernalstatus_EOI
!:
	// Restore proper IECPROTO value
	lda #$01
	sta IECPROTO

	// Re-enable sprites
	pla
	sta VIC_SPENA

	// End byte reception
	jmp iec_rx_end


#endif // CONFIG_IEC_JIFFYDOS
