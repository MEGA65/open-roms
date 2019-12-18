
//
// Tape (turbo) helper routine - pulse reading
//
// Returns pulse length (with a bias, see comments) in .A
//


#if CONFIG_TAPE_NORMAL


tape_load_get_pulse:

	// Contrary to original ROM implementation we do not use interrupts
	// (see http://unusedino.de/ec64/technical/formats/tap.html) - busy wait
	// implementation is probably just shorter

	lda #$10
!:
	bit CIA1_ICR    // $DC0D
	bne !-
!:   
	bit CIA1_ICR    // $DC0D
	beq !-                             // busy loop to detect signal, restart timer afterwards
	lda CIA2_TIMBLO // $DD06
	ldx #%01010001                     // start timer, force latch reload, count timer A underflows
	stx CIA2_CRB    // $DD0F

	// Since the signal appeared to the point of timer restart we used:
	// bit - 4 cycles
	// beq - 2 cycles
	// lda - 4 cycles
	// ldx - 2 cycles
	// stx - 4 cycles
	// plus approx. 3 cycles (bit + beq time divided by 2) from value change to 'bit' instruction,
	// this is total 19 cycles, or $5 periods of 4 ticks (timer A) each - we need to take it into account
	// every time we check the pulse length

	rts


#endif
