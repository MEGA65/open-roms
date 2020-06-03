// #LAYOUT# STD *        #TAKE
// #LAYOUT# M65 KERNAL_1 #TAKE
// #LAYOUT# *   *        #IGNORE

//
// Tape head alignemnt tool - helper routine for reading pulses
//


#if CONFIG_TAPE_HEAD_ALIGN


tape_head_align_get_pulse:

	// This routine differs from the one used to read pulse during tape reading:
	// - it is not as precise
	// - it terminates when timer reaches $FF

	lda #$10
!:
	// Loop to detect signal

	ldy CIA2_TIMBLO // $DD06
	bit CIA1_ICR    // $DC0D
	bne !+

	cpy #$FF
	bne !-
!:
	// Start timer again, force latch reload, count timer A underflows

	ldx #%01010001
	stx CIA2_CRB    // $DD0F

	// Return with time elapsed

	tya
	rts

#endif // CONFIG_TAPE_HEAD_ALIGN
