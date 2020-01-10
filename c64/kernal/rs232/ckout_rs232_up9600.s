#if ROM_LAYOUT_STD || (ROM_LAYOUT_M65 && SEGMENT_KERNAL_0)

//
// RS-232 part of the CKOUT routine
//

// Based on UP9600 code by Daniel Dallman with Bo Zimmerman adaptations


#if CONFIG_RS232_UP9600


ckout_rs232:

	// XXX adapt this

	lda #$02
	sta DFLTO
	jsr ENABLE
	clc
	rts


#endif // CONFIG_RS232_UP9600


#endif // ROM layout
