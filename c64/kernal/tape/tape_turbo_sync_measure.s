#if ROM_LAYOUT_STD || (ROM_LAYOUT_M65 && SEGMENT_KERNAL_0)

//
// Tape (turbo) helper routine - measure bit length for calibration purposes
//

#if CONFIG_TAPE_TURBO && CONFIG_TAPE_TURBO_AUTOCALIBRATE


tape_turbo_sync_measure_0:

	// Measure bit '0'
	jsr tape_turbo_get_bit
	bcs tape_turbo_sync_measure_fail
	txa
	adc STACK+2
	sta STACK+2
	bcc !+
	inc STACK+0
!:
	rts

tape_turbo_sync_measure_1:

	// Measure bit '1'
	jsr tape_turbo_get_bit
	bcc tape_turbo_sync_measure_fail
	txa
	adc STACK+3
	sta STACK+3
	bcc !+
	inc STACK+1
!:
	rts

tape_turbo_sync_measure_fail:

	pla
	pla
	jmp tape_turbo_sync_header


#endif


#endif // ROM layout
