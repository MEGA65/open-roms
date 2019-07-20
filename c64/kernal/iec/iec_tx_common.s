
;; This is a common part of iec_tx_byte and iec_tx_command
;; Implemented based on https://www.pagetable.com/?p=1135, https://github.com/mist64/cbmbus_doc
;; and http://www.zimmers.net/anonftp/pub/cbm/programming/serial-bus.pdf

;; Expects byte to send in BSOUR; Carry flag set = signal EOI


iec_tx_common:

	;; Timing is critical here - execute on disabled IRQs
	php
	sei

	;; Wait till all receivers are ready, they should all release DATA
	jsr iec_wait_for_data_release

	;; At this point a delay 256 usec or more is considered EOI - add waits if necessary
	bcc +
	jsr iec_wait100us
	jsr iec_wait100us
	jsr iec_wait60us

	;; XXX waits above should be enough - why do we need more waits???
	jsr iec_wait100us
	jsr iec_wait100us
	jsr iec_wait100us

	;; Receiver should now acknowledge EOI by pulling data for at least 60 usec
	jsr iec_wait60us
	jsr iec_wait_for_data_release
*
	;; Pull CLK back to indicate that DATA is not valid, keep it for 60us
	;; We can use this routine as we don't hold DATA anyway (and its state doesn't even matter)

	jsr iec_pull_clk_release_data
	jsr iec_wait60us
	
	;; Now, we can start transmission of 8 bits of data
	ldx #7

iec_tx_common_sendbit:
	;; Is next bit 0 or 1?
	lda BSOUR
	lsr
	sta BSOUR
	bcs +
	;; XXX we are actually destroying BSOUR here... is it allowed?

	;; Bit is 0
	jsr iec_release_clk_pull_data
	jmp iec_tx_common_bit_is_sent
*
	;; Bit is 1
	jsr iec_release_clk_data
	
iec_tx_common_bit_is_sent:

	;; Wait 20us, so that device(s) can pick DATA
	jsr iec_wait20us
		
	;; Pull CLK for 20us again, before sending the next bit
	;; or performing any other action
	jsr iec_pull_clk_release_data
	jsr iec_wait20us ; XXX this might be an overkill, there is a lot of code besides this wait here - few NOPs might be enough

	;; More bits to send?
	dex
	bpl iec_tx_common_sendbit

	plp
	rts ; Flow continues differently for data/command

