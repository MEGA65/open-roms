
//
// Advertise burst IEC protocol support to the receiver
//

//
// Based on idea by Pasi 'Albert' Ojala and description from
// https://sites.google.com/site/h2obsession/CBM/C128/fast-serial-for-uiec
//


#if CONFIG_IEC_BURST_CIA1


burst_advertise:

#if CONFIG_IEC_JIFFYDOS

	// Skip if other protocol (only JiffyDOS is possible at this moment) already detected
	lda IECPROTO
	bmi !+
	bne burst_advertise_done              
!:
#endif

	panic #$FF // XXX implement this

burst_advertise_done:

	rts


#endif
