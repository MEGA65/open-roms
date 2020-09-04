// #LAYOUT# M65 KERNAL_0 #TAKE
// #LAYOUT# *   *        #IGNORE

//
// Automatic switching to legacy C64 mode if loading anything below $0800
//

#if CONFIG_TAPE_NORMAL || CONFIG_TAPE_TURBO


m65_load_autoswitch_tape:

	lda VERCKK
	bne m65_load_autoswitch_done       // no autoswitch for VERIFY

	lda STAL+1

#endif

m65_load_autoswitch:

	lda VERCKK
	bne m65_load_autoswitch_done       // no autoswitch for VERIFY

	lda EAL+1

	// FALLTROUGH

m65_load_autoswitch_check:

	cmp #$08
	bcs m65_load_autoswitch_done       // no autoswitch if loading above $07FF

	jsr M65_MODEGET
	bcs m65_load_autoswitch_done       // no autoswitch if already in legacy mode

	sec
	jmp M65_MODESET

	// XXX consider displaying something here

m65_load_autoswitch_done:

	rts
