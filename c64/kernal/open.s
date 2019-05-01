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

	;; CLK is now asserted, and we are ready to transmit a byte
	lda #$28
	jsr iec_tx_byte
	bcs open_error

	;; Indicate success
	lda #$00
	clc	

open_error:	
	;; Re-enable interrupts and return
	;; (iec_tx_byte will have set/cleared C flag and put result code
	;; in A if it was an error).
	cli
	rts
