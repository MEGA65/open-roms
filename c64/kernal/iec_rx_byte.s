	;; Receive a byte from the IEC bus.
	;; reference http://www.zimmers.net/anonftp/pub/cbm/programming/serial-bus.pdf
	;; page 11.


iec_rx_byte:

	;; First, we wait for the talker to release the CLK line.
	jsr iec_wait_for_clock_release

	;; We then release the data line
	;; (We can use this routine, since we weren't holding CLK, anyway)
	jsr iec_release_clk_and_data

	;; Wait for talker to assert CLK.
	;; If >200usec, then it is EOI and we have to assert the
	;; DATA line for 60 usec to tell the TALKER that we have
	;; acknowledged the EOI.
	ldx #20
iec_rx_clk_wait:
	;; Loop takes 11 usec, so ~20 iterations for 200usec timeout
	lda $dd00
	bpl +
	dex
	bpl iec_rx_clk_wait

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

*
	;; CLK is now low.  Latch input bits in on rising edge
	;; of CLK, eight times for eight bits.
	ldx #7

	lda #$00
	php
	
iec_rx_bit_loop:	
	;; Wait for CLK to release
	jsr iec_wait_for_clock_release
	;; DATA now has the next bit, but inverted.
	;; DATA is in bit6, which is a bit annoying.
	;; But we can clock it out with two ROL instructions
	;; so that it is in C. We can then ROL it into the
	;; partial data byte
	;; Move data bit into C flag
	LDA $DD00
	ROL
	ROL
	;; Pull it into the data byte
	pla
	ROL
	eor #$01  		; Invert the data bit
	pha

	;; Wait for CLK to re-assert
	jsr iec_wait_for_clock_assert

	;; More bits?
	dex
	bpl iec_rx_bit_loop

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
	
