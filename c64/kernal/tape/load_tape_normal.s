
//
// Tape (normal) part of the LOAD routine
//


// We have the following possible CPU frequencies:
// - C64    PAL:  CPU frequency 0.985248 MHz
// - C64    NTSC: CPU frequency 1.022727 MHz
// - VIC-20 PAL:  CPU frequency 1.108405 MHz
// - VIC-20 NTSC: CPU frequency 1.022727 MHz
// Since VIC-20 tapes are not expected to be loaded often, routine will be optimized for C64 timings

// We have to distinguish the following pulse lengths (http://sidpreservation.6581.org/tape-format/):
// - S (short)    352 us
// - M (medium)   512 us
// - L (long)     672 us
// This gives us the following thresholds (where average CPU frequency is 1.0039875 MHz):
// - S vs M       432 us (54 8-cycle periods)
// - M vs L       592 us (74 8-cycle periods)

// The following encoding is used:
// (S,M) = 0 bit
// (M,S) = 1 bit
// (L,M) = new-data marker
// (L,S) = end-of-data marker


#if CONFIG_TAPE_NORMAL


load_tape_normal:
	STUB_IMPLEMENTATION()


#endif
