
// Implemented based on https://www.pagetable.com/?p=1135, https://github.com/mist64/cbmbus_doc

// Expects byte to send in TBTCNT ($A4 is a byte buffer according to http://sta.c64.org/cbm64mem.html)
// Carry flag set = signal EOI
//
// Preserves .X and .Y registers


iec_tx_command:

	// Store .X and .Y on the stack - preserve them
	txa
	pha
	tya
	pha

	// Notify all devices that we are going to send a byte
	// and it is going to be a command (pulled ATN)
	jsr iec_pull_atn_clk_release_data

	// Give devices time to respond (response is mandatory!) by pulling DATA
	jsr iec_wait1ms
	lda CIA2_PRA // pulled DATA = highest bit 0 = 'plus'
	bpl !+
	jmp iec_return_DEVICE_NOT_FOUND
!:
	// At least one device responded, but they are still allowed to stall
	// (can be busy processing something), we have to wait till they are all
	// ready (or bored with DOS attack...)
	// Release back CLK, keep DATA released - to ask devices for status.

	jsr iec_release_clk_data

	// Common part of iec_txbyte and iec_tx_common - waits for devices
	// and transmits a byte

	clc // Carry flag set is used for EOI mark
	jmp iec_tx_common

