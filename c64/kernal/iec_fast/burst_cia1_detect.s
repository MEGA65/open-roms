
//
// Helper routine for burst IEC protocol support
//

//
// Based on idea by Pasi 'Albert' Ojala
//


#if CONFIG_IEC_BURST_CIA1


burst_detect:

#if CONFIG_IEC_JIFFYDOS || CONFIG_IEC_DOLPHINDOS

	lda IECPROTO
	bmi !+
	bne burst_detect_fail              // skip if other protocol already detected
!:
#endif

	panic #$FF // XXX implement this

burst_detect_fail:

	rts


#endif
