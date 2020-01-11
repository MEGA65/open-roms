#if ROM_LAYOUT_STD || (ROM_LAYOUT_M65 && SEGMENT_KERNAL_0)

//
// Official Kernal routine, described in:
//
// - [RG64] C64 Programmers Reference Guide   - page 277/278
// - [CM64] Computes Mapping the Commodore 64 - page 228
//
// CPU registers that has to be preserved (see [RG64]): .Y
//

// Reads a byte of input, unless from keyboard.
// If from keyboard, then it gets a whole line of input, and returns the first char.
// Repeated calls after that read out the successive bytes of the line of input.


CHRIN:

	// Determine the device number
	lda DFLTN

	// Try $00 - keyboard
	beq_16 chrin_keyboard

	// XXX Try $03 - screen
	// cmp #$03
	// beq_16 chrin_screen

#if HAS_RS232

	// Try $02 - RS-232
	cmp #$02
	beq_16 chrin_rs232

#endif // HAS_RS232

chrin_getin: // jump entry for GETIN

#if CONFIG_IEC

	// Try IEC devices
	jsr iec_check_devnum_oc
	bcc_16 chrin_iec

#endif // CONFIG_IEC

	// Not a supported device

	jmp lvs_device_not_found_error


#endif // ROM layout
