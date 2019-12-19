
//
// Tape (turbo) helper routine - handling the pilot
//


#if CONFIG_TAPE_NORMAL


tape_normal_pilot:

	// Injest the pilot - series of short pulses. According to http://sidpreservation.6581.org/tape-format/
	// it consist of the foollowing number of pulses:
	// - $6A00 for header
	// - $1A00 for data and seq block header
	// - $4F for repeated header/data

	ldy #$05                           // this should be enough
!:
	jsr tape_normal_get_pulse
	bcc tape_normal_pilot              // not a pilot - try again

	dey
	bne !-

	rts


#endif
