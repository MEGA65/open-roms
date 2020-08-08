// #LAYOUT# STD *        #TAKE
// #LAYOUT# M65 KERNAL_1 #TAKE
// #LAYOUT# *   *        #IGNORE

//
// Handle screen (visible/blanked) + tape deck motor (on/off),
// store/restore screen color
//


#if CONFIG_TAPE_NORMAL || CONFIG_TAPE_TURBO


// XXX for Mega65 do not disable screen, just disable badline emulation


tape_screen_on_motor_off:

	jsr tape_motor_off

	lda COLSTORE
	sta VIC_EXTCOL

#if !CONFIG_MB_MEGA_65

	jmp screen_on

#else

	// On Mega65 just reenable badline emulation

	lda #$FF
	sta M65_BADL_SLI
	sta VIC_KEY

	rts

#endif


tape_screen_off_motor_on:

	// We do not want interrupts and CHROUT reenables them
	sei

	// Clear keyboard buffer
	lda #$00
	sta NDX	

	// Set screen color
	lda VIC_EXTCOL
	sta COLSTORE

#if !CONFIG_MB_MEGA_65
	
	jsr screen_off

#else

	// On Mega65 we do not have to turn the screen off;
	// it is enough to disable badline emulation

	jsr viciv_unhide
	lda #$00
	sta M65_BADL_SLI

#endif


	jmp tape_motor_on

#endif
