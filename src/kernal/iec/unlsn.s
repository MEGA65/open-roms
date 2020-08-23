// #LAYOUT# STD *        #TAKE
// #LAYOUT# *   KERNAL_0 #TAKE
// #LAYOUT# *   *        #IGNORE

//
// Official Kernal routine, described in:
//
// - [RG64] C64 Programmers Reference Guide   - page 303
// - [CM64] Computes Mapping the Commodore 64 - page 224
// - https://www.pagetable.com/?p=1031, , https://github.com/mist64/cbmbus_doc
// - http://www.zimmers.net/anonftp/pub/cbm/programming/serial-bus.pdf
//
// CPU registers that has to be preserved (see [RG64]): .X, .Y
//


UNLSN:

#if CONFIG_IEC || ROM_LAYOUT_M65

	// According to serial-bus.pdf (page 15) this routine flushes the IEC out buffer
	jsr iec_tx_flush

#endif

#if ROM_LAYOUT_M65

	jsr m65dos_check
	bcc_16 m65dos_unlsn                // branch if device is handeld by internal DOS

#endif

#if CONFIG_IEC

#if CONFIG_IEC_JIFFYDOS || CONFIG_IEC_DOLPHINDOS

	lda #$FF                           // do not use JiffyDOS / DolphinDOS anymore, trigger JiffyDOS detection
	sta IECPROTO

#endif

	// Buffer empty, send the command
	lda #$3F

	jmp common_open_close_unlsn_second

#else

	jmp kernalerror_ILLEGAL_DEVICE_NUMBER

#endif
