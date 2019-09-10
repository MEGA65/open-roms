
select_device:

	// Take last device number, make sure it's a drive - 8 or above. Above 30,
	// although illegal for IEC we also consider a drive, as they exists
	// drivers assigning these numbers to CBM-DOS capable devices - like some
	// IEEE-488 carts.
	//
	// If current device is not a drive, set device to 8 (first drive number)
	// Device number is left in X, for SETFLS Kernal routine

	// Note: if tape support is introduced here, make sure DOS wedge won't get broken

	ldx current_device_number
	cpx #$08
	bcs !+
	ldx #$08
!:
	rts
