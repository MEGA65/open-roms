// #LAYOUT# STD *        #TAKE
// #LAYOUT# *   KERNAL_0 #TAKE
// #LAYOUT# *   *        #IGNORE

//
// Advertise burst IEC protocol support to the receiver
//


#if CONFIG_IEC_BURST_SOFT


burst_advertise:

#if CONFIG_IEC_JIFFYDOS

	// Skip if other protocol (only JiffyDOS is possible at this moment) already detected
	lda IECPROTO
	bmi !+
	bne burst_advertise_done:              
!:
#endif

	panic #$FF // XXX implement this

burst_advertise_done:

	rts


#endif
