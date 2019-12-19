
//
// Tape (normal) part of the LOAD routine
//


// We have the following possible CPU frequencies:
// - C64    PAL:  CPU frequency 0.985248 MHz
// - C64    NTSC: CPU frequency 1.022727 MHz
// Average is 1.0039875 MHz and we will take this value for calculation (but it really does not change much).
//
// We have to distinguish the following pulse lengths (http://sidpreservation.6581.org/tape-format/):
// - S (short)    352 us
// - M (medium)   512 us
// - L (long)     672 us
//
// This gives us the following thresholds
// - S vs M       432 us (108 or $6C 4-tick periods)
// - M vs L       592 us (149 or $95 4-tick periods)
//
// 4-tick periods should be enough - TAP file format description (http://unusedino.de/ec64/technical/formats/tap.html)
// tells it uses exactly 8 PAL ticks as a resolution

// The following encoding is used:
// (S,M) = 0 bit
// (M,S) = 1 bit
// (L,M) = new-data marker
// (L,S) = end-of-data marker


// XXX use pilot to calibrate reading speed


#if CONFIG_TAPE_NORMAL


load_tape_normal:

	jsr tape_ditch_verify              // only LOAD is supported, no VERIFY

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
	
	// Start playing
	jsr tape_ask_play

	// FALLTROUGH

load_tape_normal_header:

	lda #$00
	sta ROPRTY                         // initialize EOR checksum
!:
	jsr tape_normal_pilot
	ldy #$89
	jsr tape_normal_sync
	bcs !-

	// XXX replace this placeholder with a real routine
!:
	jsr tape_normal_get_byte
	jmp !-


#endif
