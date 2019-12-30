
//
// Helper routine for burst IEC protocol support
//


#if CONFIG_IEC_BURST_SOFT


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
