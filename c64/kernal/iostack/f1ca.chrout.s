
//
// Official Kernal routine, described in:
//
// - [RG64] C64 Programmer's Reference Guide   - page 278/279
// - [CM64] Compute's Mapping the Commodore 64 - page 228
//
// CPU registers that has to be preserved (see [RG64]): .Y
// Additionally we have to preserve .X for out CHRIN and implementation
//

CHROUT:

	sta SCHAR

	// Save X and Y values
	// (Confirmed by writing a test program that X and Y
	// don't get modified, in agreement with C64 PRG's
	// description of CHROUT)

	phx_trash_a
	phy_trash_a

	php

	// Determine the device number
	lda DFLTO

	cmp #$03 // screen
	beq_far chrout_screen

#if HAS_RS232
	cmp #$02 
	beq_far chrout_rs232
#endif

#if CONFIG_IEC
	jsr iec_check_devnum_oc
	bcc_far chrout_iec
#endif

	// FALLTROUGH

chrout_done_fail:

	plp

	// Restore X and Y
	ply_trash_a
	plx_trash_a

	sec // indicate failure
	rts

chrout_done_unknown_device:

	plp

	// Restore X and Y
	ply_trash_a
	plx_trash_a

	// End wioth error
	jmp lvs_device_not_found_error

chrout_done_success:
	
	plp

	// Restore X and Y
	ply_trash_a
	plx_trash_a

	lda SCHAR
	clc // indicate success
	rts
