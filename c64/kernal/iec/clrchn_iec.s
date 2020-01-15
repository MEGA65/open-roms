// #LAYOUT# STD *        #TAKE
// #LAYOUT# *   KERNAL_0 #TAKE
// #LAYOUT# *   *        #IGNORE

//
// IEC part of the CLRCHN routine
//


#if CONFIG_IEC


clrchn_iec:

	// Check input device
	lda DFLTN
	jsr iec_check_devnum_oc
	bcs !+

	// It was IEC device - send UNTALK first
	jsr UNTLK
!:
	// Check output device
	lda DFLTO
	jsr iec_check_devnum_oc

	// If it was IEC device - send UNLSN first
	bcc_16 UNLSN

	rts


#endif // CONFIG_IEC
