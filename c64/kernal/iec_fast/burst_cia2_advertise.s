
//
// Advertise burst IEC protocol support to the receiver
//

//
// Based on idea by Pasi 'Albert' Ojala and description from
// https://sites.google.com/site/h2obsession/CBM/C128/fast-serial-for-uiec
//


#if CONFIG_IEC_BURST_CIA2


burst_advertise:

#if CONFIG_IEC_JIFFYDOS

	// Skip if other protocol (only JiffyDOS is possible at this moment) already detected
	lda IECPROTO
	bmi !+
	bne burst_advertise_done              
!:
#endif

	// Make sure this is not done under ATN
	jst iec_release_atn

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

	// FALLTROUGH

burst_advertise_done:

	rts


#endif
