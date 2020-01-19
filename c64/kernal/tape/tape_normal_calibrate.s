// #LAYOUT# STD *        #TAKE
// #LAYOUT# *   KERNAL_0 #TAKE
// #LAYOUT# *   *        #IGNORE

//
// Tape (normal) helper routine - reading speed calibration
//
// Needs pulse length in .A
//


#if CONFIG_TAPE_NORMAL


tape_normal_calibrate_during_pilot:    // reecalibration during the pilot

	sta __normal_time_S

	// We do not have any recent medium pulse measurement,
	// probably the only solution is to estimate it

	lda $FF
	sec
	sbc __normal_time_S

	// We now have a difference from the starting point ($FF)

	clc
	rol
	sta __normal_time_M                // this is temporary only!

	// We now have half the difference, substract it from
	// short pulse measurement result

	lda __normal_time_S
	clc
	sbc __normal_time_M

	// XXX add some constant to get a proper __normal_time_M ($7D if starting from $A5), afterwards remove __normal_time_M initialization from tape_normal_get_pilot_header

	sta __normal_time_M

	jmp tape_normal_calibrate_common


tape_normal_calibrate_after_S:         // recalibration after short pulse

	sta __normal_time_S
	rts
	skip_2_bytes_trash_nvz

	// FALLTROUGH

tape_normal_calibrate_after_M:         // recalibration after medium pulse

	sta __normal_time_M

	// FALLTROUGH

tape_normal_calibrate_common:

	// Now compare results with current threshold

	lda __normal_time_S
	sec
	sbc __pulse_threshold
	clc
	adc __normal_time_M

	cmp __pulse_threshold
	beq tape_normal_calibrate_done     // branch if no recalibration needed



	// XXX implement recalibration





tape_normal_calibrate_done:

	rts


#endif
