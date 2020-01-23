// #LAYOUT# STD *        #TAKE
// #LAYOUT# *   KERNAL_0 #TAKE
// #LAYOUT# *   *        #IGNORE

//
// Tape (normal) part of the LOAD routine
//


// We have the following possible CPU frequencies:
// - C64    PAL:  CPU frequency 0.985248 MHz
// - C64    NTSC: CPU frequency 1.022727 MHz
// The clock difference is about 4% - it is unlikely to cause problems.
//
// We have to distinguish the following pulse lengths (http://sidpreservation.6581.org/tape-format/):
// - S (short)    tap value $30 (PAL: 352 us)
// - M (medium)   tap value $42 (PAL: 512 us)
// - L (long)     tap value $56 (PAL: 672 us)
//
// The TAP format (http://unusedino.de/ec64/technical/formats/tap.html) uses a resolution of 8 PAL ticks;
// this implementation sets the timer for twice the precision (timer B is triggered every 4 CPU cycles),
// probably an overkill, but in realityy it does not cost us anything.
//
// So - we have the following thresholds:
// - S vs M       $72 (in our units of 4 ticks)
// - M vs L       $98 (in our units of 4 ticks)
//
// We need to recognize the following pulse sequences:
//
// (S,M) = 0 bit
// (M,S) = 1 bit
// (L,M) = new-data marker
// (L,S) = end-of-data marker


// XXX add error correction
// XXX implement proper takeover to turbo during sync/pilot


#if CONFIG_TAPE_NORMAL


#if !CONFIG_TAPE_AUTODETECT

load_tape_normal:

	jsr tape_ditch_verify              // only LOAD is supported, no VERIFY

	// Start playing
	jsr tape_common_prepare_cia
	jsr tape_ask_play

#else

load_tape_normal_takeover:             // entry point for turbo->normal takeover

#endif

	// FALLTROUGH

load_tape_normal_header:

	// Try to load header into tape buffer (we will restore MEMUSS later)

	jsr tape_normal_get_pilot_header

	jsr load_tape_normal_buf_MEMUSS
	jsr tape_normal_get_data_1
	bcs load_tape_normal_header        // unable to read block, try again     XXX jump to turbo detection

	jsr load_tape_normal_buf_MEMUSS
	jsr tape_normal_get_data_2
	bcs load_tape_normal_header        // block load error, try again         XXX jump to turbo detection

	// Check header type

	ldy #$00                           // XXX probably can be optimized for 65C02
	lda (TAPE1),y

	cmp #$05
	beq_16 tape_load_error             // end of tape mark, nothing to load

	cmp #$01
	beq !+
	cmp #$03
	bne load_tape_normal_header        // header types 1 and 3 are loadable, see Mapping the C64, page 77

	lda #$01
	sta SA                             // this file is non-relocatable; override secondary address with 1
!:
	// Restore MEMUSS, handle header

	jsr lvs_setup_MEMUSS
	jsr tape_handle_header
	bcs load_tape_normal_header        // if name does not match, look for other header

	// FALLTROUGH

load_tape_normal_payload:

	// Retrieve data

	jsr tape_normal_get_pilot_data
	ldy #$00                           // no data size limit
	jsr tape_normal_get_data_1
	bcs_16 tape_load_error

	jsr lvs_check_EAL
	bne_16 tape_load_error             // amount of data read does not match header info

	// XXX setup MEMUSS once again
	jsr tape_normal_get_data_2
	bcs_16 tape_load_error

	jmp tape_load_success


load_tape_normal_buf_MEMUSS:           // set MEMUSS (start address) as tape buffer 

	lda TAPE1+1
	sta MEMUSS+1
	lda TAPE1+0
	sta MEMUSS+0

	rts


#endif
