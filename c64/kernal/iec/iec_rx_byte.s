#if ROM_LAYOUT_STD || (ROM_LAYOUT_M65 && SEGMENT_KERNAL_0)

// Receive a byte from the IEC bus.
// Implemented based on https://www.pagetable.com/?p=1135, https://github.com/mist64/cbmbus_doc,
// http://www.zimmers.net/anonftp/pub/cbm/programming/serial-bus.pdf (page 11)
//
// Preserves .X and .Y registers


#if CONFIG_IEC


#if CONFIG_IEC_JIFFYDOS

iec_rx_dispatch:

	lda IECPROTO
	cmp #$01
	beq_far jiffydos_rx_byte

	// FALLTROUGH

#endif // CONFIG_IEC_JIFFYDOS


iec_rx_byte:

	// Store .X and .Y on the stack - preserve them
	phx_trash_a
	phy_trash_a

	// Timing is critical here - execute on disabled IRQs
	// The best practice would be to do PHP first, but it seems this is not
	// what the original ROM does; furthermore, pushing additional bytes to
	// stack can wreck autostart softwaree loading at $0100
	sei

	// First, we wait for the talker to release the CLK line
	jsr iec_wait_for_clk_release

	// We then release the DATA to signal we are ready
	// We can use this routine, since we were not pulling CLK anyway
	jsr iec_release_clk_data

	// Wait till data line is released (someone else might be holding it)
	jsr iec_wait_for_data_release

	// Check if EOI
	jsr iec_rx_check_eoi

#if CONFIG_IEC_DOLPHINDOS

	// Check if DolphinDOS was detected
	lda IECPROTO
	cmp #$02
	bne iec_rx_no_dolphindos

	// For DolphinDOS just fetch the byte from parallel port
	lda CIA2_PRB
	pha
	jmp iec_rx_acknowledge

iec_rx_no_dolphindos:

#endif // CONFIG_IEC_DOLPHINDOS

	// Latch input bits in on rising edge of CLK, eight times for eight bits.
	ldx #7

	// Get empty byte to load into.
	lda #$00
	pha

iec_rx_bit_loop:

	// Wait for CLK to release
	jsr iec_wait_for_clk_release

	// (we do this implicitly below, with a tighter routine,
	// so that we do not have timing problems, as the requirements
	// are quite tight. Basically we need to read the clock and data
	// bit from the same byte read.

	// DATA now has the next bit, but inverted (well, except that it turns out not to be).
	// DATA is in bit 7, which is a bit annoying.
	// But we can clock it out with a ROL instruction
	// so that it is in C. We can then ROR it into the
	// partial data byte.
	// We use ROR so that we shift in from the top, so that
	// the first bit we shift in ends up in bit 0 after all
	// 8 bits have been read.
	// ODD: For some reason we don't need to invert the
	// received bits.  This is weird, because we invert them
	// on the way out, and everything in the protocol seems
	// to indicate that we sould do so.  But experimentation
	// has confirmed the bits don't need inversion on reception.

	// Move data bit into C flag, and loop until bit 6 clears
	// i.e., the clock has been released.

!:	lda CIA2_PRA
	rol
	bpl !-

	// Pull it into the data byte
	pla
	ror
	pha

	// Wait for CLK to be pulled again, over 300 usec (307 cycles on NTSC)
	// consider this a timeout
	ldy #$19                // 2 cycles
iec_rx_clk_wait2:
	lda CIA2_PRA            // 4 cycles
	rol                     // 2 cycles, to put CLK in as the last bit
	bpl !+                  // 2 cycles if not jumped
	dey                     // 2 cycles
    bne iec_rx_clk_wait2    // 3 cycles if jumped
    
	// Timeout
	jsr kernalstatus_EOI
	pla

	jmp iec_rx_end
!:
	// More bits?
	dex
	bpl iec_rx_bit_loop

	// FALLTROUGH

iec_rx_acknowledge:

	// Then we must within 1000 usec acknowledge the byte by
	// pulling DATA. At this point, CLK is pulled by the
	// talker and DATA by us, i.e., we are ready to receive
	// the next byte. (p11).
	jsr iec_release_clk_pull_data

	// Retrieve the received byte
	pla
	
	// Restore registers
	sta TBTCNT // $A4 is a byte buffer according to http://sta.c64.org/cbm64mem.html
	
	// FALLTROUGH

iec_rx_end:

	ply_trash_a
	plx_trash_a
	lda TBTCNT

	clc
	cli
	rts


#endif // CONFIG_IEC


#endif // ROM layout
