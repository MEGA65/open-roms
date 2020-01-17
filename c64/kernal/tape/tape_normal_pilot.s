// #LAYOUT# STD *        #TAKE
// #LAYOUT# *   KERNAL_0 #TAKE
// #LAYOUT# *   *        #IGNORE

//
// Tape (turbo) helper routine - handling the pilot
//

// Injest the pilot - series of short pulses. According to http://sidpreservation.6581.org/tape-format/
// it consist of the following number of pulses:
// - $6A00 for header
// - $1A00 for data and seq block header
// - $4F for repeated header/data


#if CONFIG_TAPE_NORMAL



tape_normal_pilot_short: // require 1x $40 pulses

	lda #$01

	// FALLTROUGH

tape_normal_pilot_common:

	sta FSBLK

	// FALLTROUGH

tape_normal_pilot_common_restart:

	lda #$0B
	sta VIC_EXTCOL

	lda FSBLK
	sta ROPRTY

	// FALLTROUGH

tape_normal_pilot_common_loop_outer:

	ldy #$40

	// FALLTROUGH

tape_normal_pilot_common_loop_inner:

	jsr tape_normal_get_pulse
	bcc tape_normal_pilot_common_restart         // not a pilot - try again

	dey
	bne tape_normal_pilot_common_loop_inner

	dec ROPRTY
	bne tape_normal_pilot_common_loop_outer

	rts



tape_normal_pilot_data: // require 4x $40 pulses

	lda #$04

	skip_2_bytes_trash_nvz

	// FALLTROUGH

tape_normal_pilot_header: // require 128x $40 pulses

	lda #$80

	jmp tape_normal_pilot_common    // XXX calibrate tape speed afterwards


#endif
