
//
// Helper routine to setup CIA #2 timers
//

#if CONFIG_TAPE_NORMAL

tape_normal_setup_timers:

	ldx #$03                           // set timer A to 4 ticks

	// FALLTROUGH

#endif
#if CONFIG_TAPE_NORMAL || CONFIG_HEAD_FIT_TOOL

tape_normal_setup_timers_custom:       // entry for the head fit tool

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
