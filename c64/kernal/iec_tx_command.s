
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
	;; Release back CLK, keep DATA released - to ask devices for status.

	jsr iec_release_clk_data

	;; Common part of iec_txbyte and iec_tx_common - waits for devices
	;; and transmits a byte
	
	pla
	jsr iec_tx_common

	;; All done

	clc
	rts
