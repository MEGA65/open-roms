	;; Receive a byte from the IEC bus.
	;; reference http://www.zimmers.net/anonftp/pub/cbm/programming/serial-bus.pdf
	;; page 11.


iec_rx_byte:

	inc $062f
	
	;; First, we wait for the talker to release the CLK line.
	jsr iec_wait_for_clock_release

	inc $0630
	
	;; We then release the data line
	;; (We can use this routine, since we weren't holding CLK, anyway)
	jsr iec_release_clk_and_data

	inc $0631
	
	;; Wait for talker to assert CLK.
	;; If >200usec, then it is EOI and we have to assert the
	;; DATA line for 60 usec to tell the TALKER that we have
	;; acknowledged the EOI.
	ldx #20
iec_rx_clk_wait:
	;; Loop takes 11 usec, so ~20 iterations for 200usec timeout
	lda $dd00
	rol
	bpl not_eoi
	dex
	bpl iec_rx_clk_wait

	inc $0632
	inc $d020
	
	;; EOI timeout: So pulse DATA line for 60 usec
	jsr iec_assert_data
	jsr iec_wait60us
	jsr iec_release_clk_and_data

	;; Assert some kind of flag so that we know if it was EOI = the last byte on offer
	
	;; And still wait for CLK to be asserted
	;; XXX - This will cause periodic EOI pulses if the sender takes too long.
	;; That is probably ok.
	ldx #$7f
	jmp iec_rx_clk_wait

not_eoi:	
	;; CLK is now low.  Latch input bits in on rising edge
	;; of CLK, eight times for eight bits.
	ldx #7

	;; Get empty byte to load into.
	lda #$00
	pha
	
iec_rx_bit_loop:

	;; Wait for CLK to release
	;; jsr iec_wait_for_clock_release
	;; (we do this implicitly below, with a tighter routine,
	;; so that we don't have timing problems, as the requirements
	;; are quite tight. Basically we need to read the clock and data
	;; bit from the same byte read.

	;; DATA now has the next bit, but inverted (well, except that it turns out not to be).
	;; DATA is in bit7, which is a bit annoying.
	;; But we can clock it out with a ROL instruction
	;; so that it is in C. We can then ROR it into the
	;; partial data byte.
	;; We use ROR so that we shift in from the top, so that
	;; the first bit we shift in ends up in bit 0 after all
	;; 8 bits have been read.
	;; ODD: For some reason we don't need to invert the
	;; received bits.  This is weird, because we invert them
	;; on the way out, and everything in the protocol seems
	;; to indicate that we sould do so.  But experimentation
	;; has confirmed the bits don't need inversion on reception.
	
	;; Move data bit into C flag, and loop until bit 6 clears
	;; i.e., the clock has been released.
*	LDA $DD00
	ROL
	bpl -
	
	;; Pull it into the data byte
	pla
	ROR
	pha

	;; Wait for CLK to re-assert
	jsr iec_wait_for_clock_assert

	;; More bits?
	dex
	bpl iec_rx_bit_loop

	inc $0637
	
	;; Then we must within 1000usec acknowledge the frame by
	;; asserting DATA. At this point, CLK is asserted by the
	;; talker and DATA by us, i.e., we are ready to receive
	;; the next byte. (p11).
	jsr iec_assert_data

	;; Retreive the received byte
	PLA

	;; Return no-error
	CLC
	RTS
	
