	; Function defined on pp272-273 of C64 Programmers Reference Guide
	;; See also http://www.zimmers.net/anonftp/pub/cbm/programming/serial-bus.pdf

	;; Sequence is:
	;; 1. Call current device to attention as LISTENER = $20 + device
	;; 2. 
open:

	;; Disable IRQs, since timing matters!
	SEI

	;; Begin sending under attention
	jsr iec_assert_atn
	jsr iec_assert_clk_release_data

	;; Give devices time to respond
	jsr wait1ms

	;; Did a device respond? (DATA will be pulled if so)
	lda $DD00
	bmi +

	;; No devices present, so we can immediately return with device not found
	cli
	jmp kernalerror_DEVICE_NOT_FOUND
*

	;; Release CLK and wait for DATA to release.
	jsr iec_release_clk_and_data
	
	;; Wait for DATA to be released
	;; Listener is allowed to hold DATA for as long as they want.
	;; i.e., this is the part of the protocol where the listener indicates
	;; that they are busy doing something, like processing the previous
	;; character.
	jsr iec_wait_for_data_release

	;; We then wait for 60 usec (less than 200usec so we don't
	;; signal EOI), before asserting CLK again.
	jsr iec_wait60us

	;; Re-assert CLK line
	jsr iec_assert_clk_release_data

	;; CLK is now asserted, and we are ready to transmit a byte
	jsr iec_tx_byte
	
	rts
