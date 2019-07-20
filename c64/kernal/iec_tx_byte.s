
;; Implemented based on https://www.pagetable.com/?p=1135, https://github.com/mist64/cbmbus_doc

;; Expects byte to send in BSOUR; Carry flag set = signal EOI
;; Preserves .X and .Y registers


iec_tx_byte:

	;; Store .X and .Y on the stack - preserve them
	txa
	pha
	tya
	pha

	;; Notify all devices that we are going to send a byte
	;; and it is going to be a data byte (released ATN)
	jsr iec_release_atn_clk_data

	;; Common part of iec_txbyte and iec_tx_common - waits for devices
	;; and transmits a byte

	jsr iec_tx_common
	
	;; Give device time to tell if they are busy by pulling DATA
	;; They should do it within 1ms
	ldx #$FF
*	lda CIA2_PRA
	;; BPL here is checking that bit 7 clears,
	;; i.e, that the DATA line is pulled by drive
	bpl +
	dex
	bne -
	bpl iec_return_DEVICE_NOT_FOUND
*
	jmp iec_return_success


