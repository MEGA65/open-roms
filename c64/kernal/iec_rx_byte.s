	;; Receive a byte from the IEC bus.
	;; reference http://www.zimmers.net/anonftp/pub/cbm/programming/serial-bus.pdf
	;; page 11.


iec_rx_byte:

	;; First, we wait for the talker to release the CLK line.
	jsr iec_wait_for_clock_release

	;; We then release the data line

	;; Wait for talker to assert CLK.
	;; If >200usec, then it is EOI and we have to assert the
	;; DATA line for 60 usec to tell the TALKER that we have
	;; acknowledged the EOI.


	;; CLK is now low.  Latch input bits in on rising edge
	;; of CLK, eight times for eight bits.

	;; Then we must within 1000usec acknowledge the frame by
	;; asserting DATA. At this point, CLK is asserted by the
	;; talker and DATA by us, i.e., we are ready to receive
	;; the next byte. (p11).

	
