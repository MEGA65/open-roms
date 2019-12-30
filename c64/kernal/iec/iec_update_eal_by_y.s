
//
// Common EAL update routine
//


#if (CONFIG_IEC_JIFFYDOS || CONFIG_IEC_DOLPHINDOS) && !CONFIG_MEMORY_MODEL_60K


iec_update_EAL_by_Y: // note: Carry has to be set by caller!

	tya
	adc EAL+0
	sta EAL+0
	bcc !+
	inc EAL+1
!:
	rts


#endif
