// #LAYOUT# STD *        #TAKE
// #LAYOUT# *   KERNAL_0 #TAKE
// #LAYOUT# *   *        #IGNORE

//
// Official Kernal routine, described in:
//
// - [RG64] C64 Programmers Reference Guide   - page 274
// - [CM64] Computes Mapping the Commodore 64 - page 224/225
//
// CPU registers that has to be preserved (see [RG64]): .Y
//


ACPTR:

	lda IOSTATUS
	beq !+

	clc
	lda #$0D                           // tested on real ROMs
	rts
!:

#if ROM_LAYOUT_M65
	jsr m65dos_check
	bcc_16 m65dos_acptr                // branch if device is handeld by internal DOS
#endif

#if CONFIG_IEC
#if CONFIG_IEC_JIFFYDOS
	jmp iec_rx_dispatch
#else
	jmp iec_rx_byte
#endif
#else
	jmp kernalerror_ILLEGAL_DEVICE_NUMBER
#endif
