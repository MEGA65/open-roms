// #LAYOUT# STD *        #TAKE
// #LAYOUT# *   KERNAL_0 #TAKE
// #LAYOUT# *   *        #IGNORE


SELDEV:

	// Take last device number, make sure it is a drive - 8 or above. Above 30,
	// although illegal for IEC we also consider a drive, as they exists
	// drivers assigning these numbers to CBM-DOS capable devices - like some
	// IEEE-488 carts.
	//
	// If current device is not a drive, set device to 8 (first drive number)
	// Device number is left in X, for SETFLS Kernal routine

	ldx FA
	cpx #$08
	bcs !+
	ldx #$08
!:
	rts
