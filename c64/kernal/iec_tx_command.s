
;; Implemented based on https://www.pagetable.com/?p=1135, https://github.com/mist64/cbmbus_doc

iec_tx_command:

	pha

	;; Notify all devices that we are going to send a byte
	;; and it is going to be a command (pulled ATN)
	jsr iec_pull_atn_clk_release_data

	;; Give devices time to respond (response is mandatory!)
	jsr wait1ms

	;; Did at least one device respond by pulling DATA?
	lda CI2PRA
	and #BIT_CI2PRA_DAT_IN
	beq +

	;; No devices present on the bus, so we can immediately return with device not found
	pla

	jsr printf
	.byte "DBG: NO DEVICES AT ALL", $0D, 0

	jsr iec_set_idle
	jmp kernalerror_DEVICE_NOT_FOUND
*
	;; At least one device responded, but they are still allowed to stall
	;; (can be busy processing something), we have to wait till they are all
	;; ready (or bored with DOS attack...)
	;; - release back CLK, keep DATA released
	;; - afterwards wait till all devices also release DATA

	jsr iec_release_clk_data
	jsr iec_wait_for_data_release

	;; Pull CLK back to indicate that DATA is not valid, keep it for 60us
	;; Don't wait too long, as 200us or more is considered EOI

	jsr iec_pull_clk_release_data
	jsr iec_wait60us

	;; Now, we can start transmission of 8 bits of data
	ldx #7
	pla

iec_tx_command_nextbit:
	;; Is next bit 0 or 1?
	lsr
	pha
	bcs +

	;; Bit is 0
	jsr iec_release_clk_pull_data
	jmp iec_tx_command_bitset
*
	;; Bit is 1
	jsr iec_release_clk_data
	
iec_tx_command_bitset:

	;; Wait 20us, so that device(s) can pick DATA
	jsr iec_wait20us

	;; Pull CLK for 20us again
	jsr iec_pull_clk_release_data
	jsr iec_wait20us

	;; More bits to send?
	pla
	dex
	bpl iec_tx_command_nextbit

	;; XXX the flow below is REALLY dangerous, as if there are multiple devices,
	;; one can signal that it's busy much earlier (more than 100ms) than the other.
	;; Can we do something about it?

	;; All done - give devices time to tell if they are busy by pulling DATA
	;; They should do it within 1ms
	ldx #$FF
*	lda CI2PRA
	;; BPL here is checking that bit 7 of $DD00 clears,
	;; i.e, that the DATA line is pulled by drive
	bpl +
	dex
	bne -
	bpl iec_tx_command_done
*
	;; Wait 100us to give busy devices some time
	jsr iec_wait100us
	
iec_tx_command_done:

	clc
	rts
