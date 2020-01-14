#if ROM_LAYOUT_STD || (ROM_LAYOUT_M65 && SEGMENT_KERNAL_0)


#if CONFIG_TAPE_NORMAL || CONFIG_TAPE_TURBO


tape_common_prepare_cia:

	// Setup CIA #2 timers
	
	ldx #$03                           // set timer A to 4 ticks
	stx CIA2_TIMALO // $DD04
	ldx #$00
	stx CIA2_TIMAHI // $DD05

	stx CIA2_TIMBHI // $DD07
	dex                                // puts $FF - for running timer B as long as possible
	stx CIA2_TIMBLO // $DD06

	// Let timer A run continuously

	ldx #%00010001                     // start timer, force latch reload
	stx CIA2_CRA    // $DD0E

	rts

#endif


#endif // ROM layout
