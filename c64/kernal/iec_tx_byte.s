
;; Implemented based on https://www.pagetable.com/?p=1135, https://github.com/mist64/cbmbus_doc

iec_tx_byte:

	pha

	;; Notify all devices that we are going to send a byte
	;; and it is going to be a data byte (released ATN)
	jsr iec_release_atn_clk_data

	;; Common part of iec_txbyte and iec_tx_common - waits for devices
	;; and transmits a byte

	pla
	jsr iec_tx_common

	;; All done
	clc
	rts

