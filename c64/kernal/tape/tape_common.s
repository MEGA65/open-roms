
//
// Common routines for tape support
//


#if CONFIG_TAPE_NORMAL || CONFIG_TAPE_TURBO


tape_ditch_verify:

	lda VERCKK
	bne !+
	rts
!:
	pla
	pla
	jmp lvs_device_not_found_error


tape_motor_off:

	lda CPU_R6510
	ora #$20
	sta CPU_R6510 

	rts


tape_motor_on:

	lda CPU_R6510
	and #($FF - $20)
	sta CPU_R6510 

	rts


tape_ask_play:

	sei                                // timing is critical for tape loading

	jsr tape_motor_off

	ldx #__MSG_KERNAL_PRESS_PLAY
	jsr print_kernal_message

tape_wait_button_loop:

	jsr udtim_keyboard
	jsr STOP
	bcc !+

	// Stop key pressed
	pla
	pla
	cli
	jmp kernalerror_ROUTINE_TERMINATED
!:
	lda CPU_R6510
	and #$10                           // check for pressed button
	bne tape_wait_button_loop

	jsr screen_blank
	jsr tape_motor_on

	rts


tape_load_success:

	jsr screen_show
	jsr tape_motor_off

	jmp lvs_success_end


tape_load_error:

	jsr screen_show
	jsr tape_motor_off

	jmp lvs_load_verify_error


#endif
