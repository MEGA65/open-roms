// #LAYOUT# STD *        #TAKE
// #LAYOUT# M65 KERNAL_1 #TAKE
// #LAYOUT# *   *        #IGNORE

//
// Tape (normal) helper routine - reading speed calibration
//
// Needs pulse length in .A
//


#if CONFIG_TAPE_NORMAL


tape_normal_calibrate_during_pilot:              // reecalibration during the pilot

	sta __normal_time_S

	// We do not have any recent medium pulse measurement,
	// probably the only solution is to estimate it

	lda #$FF
	sec
	sbc __normal_time_S

	// We now have a difference from the starting point ($FF)

	clc
	ror
	sta __normal_time_M                          // this is temporary only!

	// We now have half the difference, substract it from
	// short pulse measurement result

	lda __normal_time_S
	sec
	sbc __normal_time_M
	
	// Add a small correction to gain $7D if starting from $A5. Dirty, ugly,
	// and imprecise hack - but in real life should be good enough

	clc
	adc #$05
	sta __normal_time_M                          // estimated medium pulse length

	jmp tape_normal_calibrate_common



tape_normal_calibrate_after_S:                   // recalibration after short pulse

	sta __normal_time_S
	rts
	skip_2_bytes_trash_nvz

	// FALLTROUGH

tape_normal_calibrate_after_M:                   // recalibration after medium pulse

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

	beq tape_normal_calibrate_done               // branch if no recalibration needed

	// Correct the thresholds (default is $91 for the S/M one)

	bcs tape_normal_calibrate_threshold_inc      // branch if .A >= memory

	// FALLTROUGH


tape_normal_calibrate_threshold_dec:

	lda __pulse_threshold
	cmp #($91-10)
	bcc tape_normal_calibrate_done               // do not decrement thresholds too far

	sec
	sbc #$02
	sta __pulse_threshold

	lda __pulse_threshold_ML
	sec
	sbc #$03
	sta __pulse_threshold_ML

	bne tape_normal_calibrate_done               // branch always


tape_normal_calibrate_threshold_inc:

	lda __pulse_threshold
	cmp #($91+11)
	bcs tape_normal_calibrate_done               // do not increment thresholds too far

	clc
	adc #$02
	sta __pulse_threshold

	lda __pulse_threshold_ML
	clc
	adc #$03
	sta __pulse_threshold_ML

	// FALLTROUGH


tape_normal_calibrate_done:

	rts


#endif
