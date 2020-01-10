#if ROM_LAYOUT_STD || (ROM_LAYOUT_M65 && SEGMENT_KERNAL_0)

//
// Official Kernal routine, described in:
//
// - [RG64] C64 Programmers Reference Guide   - page 285
// - [CM64] Computes Mapping the Commodore 64 - page 223
// - https://www.pagetable.com/?p=1031, https://github.com/mist64/cbmbus_doc
// - http://www.zimmers.net/anonftp/pub/cbm/programming/serial-bus.pdf
//
// CPU registers that has to be preserved (see [RG64]): .X, .Y
//


LISTEN:

#if CONFIG_IEC

	// According to serial-bus.pdf (page 15) this routine flushes the IEC out buffer
	jsr iec_tx_flush

	// Check whether device number is correct
	jsr iec_check_devnum_oc
	bcc !+
	jmp kernalerror_DEVICE_NOT_FOUND
!:
	// Encode and execute the command
	ora #$20

	jmp common_talk_listen

#else

	jmp kernalerror_ILLEGAL_DEVICE_NUMBER

#endif


#endif // ROM layout
