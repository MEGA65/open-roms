
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
	jsr tape_normal_setup_timers
	
	// Start playing
	jsr tape_ask_play

	// FALLTROUGH

load_tape_normal_header:

	// Read pilot and sync of the first header

	jsr tape_normal_pilot
	ldy #$89
	jsr tape_normal_sync
	bcs load_tape_normal_header

	ldy #$00

	// FALLTROUGH

load_tape_normal_header_loop:

	// Read the header

	jsr tape_normal_get_byte            // XXX handle errors
	sta (TAPE1), y
	iny
	cpy #$15
	bne load_tape_normal_header_loop

	// Read pilot and sync of the second header

	jsr tape_normal_pilot
	ldy #$09
	jsr tape_normal_sync
	bcs load_tape_normal_header

	// XXX do not skip second header, use it to correct data
	ldy #$15
!:
	jsr tape_normal_get_byte
	dey
	bne !-

	// For now only one type of header is supported

	ldy #$00
	lda (TAPE1),y

	cmp #$01
	bne load_tape_normal_header        // XXX also handle other header types, see Mapping the C64 page 77

	// Handle the header

	jsr tape_handle_header
	bcs load_tape_normal_header        // if name does not match, look for other header

	// FALLTROUGH

load_tape_normal_payload:




	// XXX replace this placeholder with a real routine
!:
	jsr tape_normal_get_byte
	jmp !-


#endif
