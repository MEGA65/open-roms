
//
// Official Kernal routine, described in:
//
// - [RG64] C64 Programmer's Reference Guide   - page 301/302
// - [CM64] Compute's Mapping the Commodore 64 - page 223
// - https://www.pagetable.com/?p=1031, https://github.com/mist64/cbmbus_doc
// - http://www.zimmers.net/anonftp/pub/cbm/programming/serial-bus.pdf
//
// CPU registers that has to be preserved (see [RG64]): .X, .Y
//


TALK:

	// According to serial-bus.pdf (page 15) this routine flushes the IEC out buffer
	jsr iec_tx_flush

	// Check whether device number is correct
	jsr iec_check_devnum
	bcc !+
	jmp kernalerror_DEVICE_NOT_FOUND
!:
	// Encode and execute the command
	ora #$40

common_talk_listen: // common part of TALK and LISTEN

	sta IEC_TMP2
	jmp iec_tx_command


