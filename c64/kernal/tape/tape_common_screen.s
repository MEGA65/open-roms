
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
	lda VIC_EXTCOL
	sta COLSTORE

	jsr screen_off
	jmp tape_motor_on

#endif
