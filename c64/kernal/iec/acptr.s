
//
// Official Kernal routine, described in:
//
// - [RG64] C64 Programmer's Reference Guide   - page 274
// - [CM64] Compute's Mapping the Commodore 64 - page 224/225
//
// CPU registers that has to be preserved (see [RG64]): .Y
//


ACPTR:

	lda IOSTATUS
	beq !+

	lda #$0D                           // tested on real ROMs
	clc
	rts
!:

#if CONFIG_IEC
#if CONFIG_IEC_JIFFYDOS || CONFIG_IEC_DOLPHINDOS
	jmp iec_rx_dispatch
#else // no turbo supported
	jmp iec_rx_byte
#endif
#else
	jmp kernalerror_ILLEGAL_DEVICE_NUMBER
#endif
