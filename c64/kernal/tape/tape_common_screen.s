// #LAYOUT# STD *        #TAKE
// #LAYOUT# M65 KERNAL_1 #TAKE
// #LAYOUT# *   *        #IGNORE

//
// Handle screen (visible/blanked) + tape deck motor (on/off),
// store/restore screen color
//


#if CONFIG_TAPE_NORMAL || CONFIG_TAPE_TURBO


tape_screen_on_motor_off:

	jsr tape_motor_off

	lda COLSTORE
	sta VIC_EXTCOL

	jmp screen_on

tape_screen_off_motor_on:

	// We do not want interrupts and CHROUT reenables them
	sei

	// Clear keyboard buffer
	lda #$00
	sta NDX	

	// Set screen color
	lda VIC_EXTCOL
	sta COLSTORE

	jsr screen_off
	jmp tape_motor_on

#endif
