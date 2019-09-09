// Receive a byte from the IEC bus.
// Implemented based on https://www.pagetable.com/?p=1135, https://github.com/mist64/cbmbus_doc,
// http://www.zimmers.net/anonftp/pub/cbm/programming/serial-bus.pdf (page 11)
//
// Preserves .X and .Y registers

iec_rx_byte:

	// Store .X and .Y on the stack - preserve them
	txa
	pha
	tya
	pha

	// Timing is critical here - execute on disabled IRQs
	php
	sei

	// First, we wait for the talker to release the CLK line
	jsr iec_wait_for_clk_release

	// We then release the DATA to signal we are ready
	// We can use this routine, since we weren't pulling CLK anyway
	jsr iec_release_clk_data

	// Wait till data line is released (someone else might be holding it)
	jsr iec_wait_for_data_release

	// Wait for talker to pull CLK.
	// If over 200 usec (205 cycles on NTSC machine) , then it is EOI.
	// Loop iteraction takes 13 cycles, 17 full iterations are enough

	ldx #$11                // 2 cycles
iec_rx_clk_wait1:
	lda CIA2_PRA            // 4 cycles
	rol                     // 2 cycles, to put CLK in as the last bit
	bpl iec_rx_not_eoi      // 2 cycles if not jumped
	dex                     // 2 cycles
    bne iec_rx_clk_wait1    // 3 cycles if jumped
    
	// Timeout - either this is the last byte of stream, or the stream is empty at all.
	// Mark end of stream in IOSTATUS
	jsr kernalstatus_EOI

iec_rx_not_empty:

	// Pull data for 60 usec to confirm it
	jsr iec_release_clk_pull_data
	jsr iec_wait60us
	jsr iec_release_clk_data

iec_rx_not_eoi:

	// Latch input bits in on rising edge of CLK, eight times for eight bits.
	ldx #7

	// Get empty byte to load into.
	lda #$00
	pha

iec_rx_bit_loop:

	// Wait for CLK to release
	jsr iec_wait_for_clk_release

	// (we do this implicitly below, with a tighter routine,
	// so that we don't have timing problems, as the requirements
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
	plp
    
	// Restore registers
	pla
	tay
	pla
	tax
    
	sec // XXX confirm that sec is really a way to report timeout here
	rts
!:
	// More bits?
	dex
	bpl iec_rx_bit_loop

	// Then we must within 1000 usec acknowledge the frame by
	// pulling DATA. At this point, CLK is pulled by the
	// talker and DATA by us, i.e., we are ready to receive
	// the next byte. (p11).
	jsr iec_release_clk_pull_data

	// Retreive the received byte
	pla

	// Return no-error
	plp
	
	// Restore registers
	sta TBTCNT // $A4 is a byte buffer according to http://sta.c64.org/cbm64mem.html
	pla
	tay
	pla
	tax
	lda TBTCNT

	clc
	rts

