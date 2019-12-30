
//
// Helper routine for burst IEC protocol support
//

//
// Based on idea by Pasi 'Albert' Ojala
//


#if CONFIG_IEC_BURST_CIA2


burst_detect:

#if CONFIG_IEC_JIFFYDOS || CONFIG_IEC_DOLPHINDOS

	lda IECPROTO
	bmi !+
	bne burst_detect_fail              // skip if other protocol already detected
!:
#endif

	// For extra safety, do it on disabled interupts
	php
	sei

	// Set the clock rate to the fastest possible
	ldy #$01
	sty CIA2_TIMALO
	dey
	sty CIA2_TIMAHI

	// Prepare registers for transfer
	lda #$C1
	sta CIA2_CRA                       // start timer A, serial out, TOD 50Hz
	bit CIA2_ICR                       // clear interrupt register

	// Send test byte
	lda #$FF                           // $FF keeps DATA released, see https://www.c64-wiki.com/wiki/Fast_serial_bus_protocol
	sta CIA2_SDR

	// Wait until byte sent
	lda #$08		                   // interrupt mask
!:
	bit CIA2_ICR                       
	beq !-

	// Now see if we get any byte back

	lda CIA2_SDR    // XXX we do not need a value, we need to know if it was received


	panic #$00      // XXX finish this routine
	

	plp

	// FALLTROUGH

burst_detect_fail:

	rts


#endif
