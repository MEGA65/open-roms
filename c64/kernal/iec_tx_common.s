
;; This is a common part of iec_tx_byte and iec_tx_command
;; Implemented based on https://www.pagetable.com/?p=1135, https://github.com/mist64/cbmbus_doc
;; and http://www.zimmers.net/anonftp/pub/cbm/programming/serial-bus.pdf

iec_tx_common:

	;; Store the bye to send on a stack
	pha
	
	;; Wait till all receivers are ready, they should all release DATA
	jsr iec_wait_for_data_release

	;; Pull CLK back to indicate that DATA is not valid, keep it for 60us
	;; We can use this routine as we don't hold DATA anyway (and its state doesn't even matter)
	;; Don't wait too long, as 200us or more is considered EOI

	jsr iec_pull_clk_release_data
	jsr iec_wait60us

	;; Now, we can start transmission of 8 bits of data
	ldx #7
	pla

iec_tx_common_sendbit:
	;; Is next bit 0 or 1?
	lsr
	pha
	bcs +

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
	jsr iec_wait20us

	;; More bits to send?
	dex
	bpl iec_tx_common_nextbit
	pla
	
	rts ; Flow continues differently for data/command
	
iec_tx_common_nextbit:

	pla
	jmp iec_tx_common_sendbit
