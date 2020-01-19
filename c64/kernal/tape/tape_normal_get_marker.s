// #LAYOUT# STD *        #TAKE
// #LAYOUT# *   KERNAL_0 #TAKE
// #LAYOUT# *   *        #IGNORE

//
// Tape (normal) helper routine - marker reading
//
// Reeturns marker type in Carry flag, set = end of data (normal marker) or failure (marker while sync)
//


#if CONFIG_TAPE_NORMAL

	// (L,M) - end of byte, (L,S) - end of data


tape_normal_get_marker: 


	jsr tape_common_get_pulse
	cmp __pulse_threshold_ML
	bcs tape_normal_get_marker                             // too short for a long pulse

	// FALLTROUGH

tape_normal_get_marker_type:

	jmp tape_common_get_pulse



!:  // Not an entry point!!!

	// XXX check for short pulses of turbo here

	jsr tape_normal_calibrate_during_pilot                 // while sync use short pulses for calibration

	// FALLTROUGH

tape_normal_get_marker_while_sync:

	// (L,M) - end of byte, (L,S) - end of data

	jsr tape_common_get_pulse
	bcs !-                                                 // branch if short pulse

	cmp __pulse_threshold_ML
	bcs tape_normal_get_marker_while_sync                  // too short for a long pulse
	
	bcc tape_normal_get_marker_type                        // branch always


#endif
