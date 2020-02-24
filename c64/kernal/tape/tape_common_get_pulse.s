// #LAYOUT# STD *        #TAKE
// #LAYOUT# M65 KERNAL_1 #TAKE
// #LAYOUT# *   *        #IGNORE

//
// Tape helper routine - pulse reading
//
// Returns pulse length (with a bias, see comments) in .A
//


#if CONFIG_TAPE_NORMAL || CONFIG_TAPE_TURBO


tape_common_get_pulse:

	// Contrary to original ROM implementation we do not use interrupts
	// (see http://unusedino.de/ec64/technical/formats/tap.html) - busy wait
	// implementation is probably just shorter

	lda #$10
!:
	bit CIA1_ICR    // $DC0D
	beq !-                             // busy loop to detect signal, restart timer afterwards
	lda CIA2_TIMBLO // $DD06
	ldx #%01010001                     // start timer, force latch reload, count timer A underflows
	stx CIA2_CRB    // $DD0F

	cmp __pulse_threshold              // sdefault pulse check
	rts


#endif
