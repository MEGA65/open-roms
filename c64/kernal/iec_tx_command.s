
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
	and #BIT_CI2PRA_DAT_IN ; XXX try to optimize this, move to separate routine
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
	;; Release back CLK, keep DATA released - to ask devices for status.

	jsr iec_release_clk_data

	;; Common part of iec_txbyte and iec_tx_common - waits for devices
	;; and transmits a byte

	clc ; Carry flag set is used for EOI mark
	pla
	jsr iec_tx_common

	;; According to https://www.pagetable.com/?p=1135 there is some complicated and dangerous
	;; flow here, but http://www.zimmers.net/anonftp/pub/cbm/programming/serial-bus.pdf (page 6)
	;; advices to just wait 1ms and check the DATA status
	jsr wait1ms
	lda CI2PRA
	and #BIT_CI2PRA_DAT_IN ; XXX try to optimize this, move to separate routine
	beq +
	
	;; XXX possible optimization of the flow above: for many commands it is enough
	;; to wait for the DATA being pulled, as confirmation is expected from
	;; a single device only - but not sure if it's worth the trouble

	jsr printf
	.byte "DBG: NO CONFIRMATION FROM DEVICE", $0D, 0

	jsr iec_set_idle
	jmp kernalerror_DEVICE_NOT_FOUND
*
	;; All done
	
	;; XXX All the documentation says we should release ATN at this point, but when I do so
	;; the turnaround mechanism does not work. Why???
	;; jsr iec_wait20us
	;; jsr iec_set_idle

	clc
	rts
