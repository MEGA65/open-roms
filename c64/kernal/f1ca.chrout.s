
//
// Official Kernal routine, described in:
//
// - [RG64] C64 Programmer's Reference Guide   - page 278/279
// - [CM64] Compute's Mapping the Commodore 64 - page 228
//
// CPU registers that has to be preserved (see [RG64]): .Y
//

CHROUT:

	sta SCHAR

	// Save X and Y values
	// (Confirmed by writing a test program that X and Y
	// don't get modified, in agreement with C64 PRG's
	// description of CHROUT)
	txa
	pha
	tya
	pha
	php

	// Determine the device number
	lda DFLTO

	cmp #$03 // screen
	bne !+
	jmp chrout_screen
!:
	jsr iec_check_devnum
	bcs chrout_done_unknown_device // not a supported device

chrout_iec:

	lda SCHAR
	jsr JCIOUT
	bcc chrout_done

	// FALLTROUGH

chrout_done_fail:
	jsr show_cursor_if_enabled

	plp

	// Restore X and Y
	pla
	tay
	pla
	tax
	sec // indicate failure
	rts

chrout_done_unknown_device:
	jsr show_cursor_if_enabled

	plp

	// Restore X and Y
	pla
	tay
	pla
	tax

	// End wioth error
	jmp lvs_device_not_found_error

chrout_done:
	jsr show_cursor_if_enabled

	plp

	// Restore X and Y
	pla
	tay
	pla
	tax
	lda SCHAR
	clc // indicate success
	rts
