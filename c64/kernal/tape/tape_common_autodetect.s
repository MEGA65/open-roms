// #LAYOUT# STD *        #TAKE
// #LAYOUT# *   KERNAL_0 #TAKE
// #LAYOUT# *   *        #IGNORE

//
// Tries to detect
//
// Carry clear - NORMAL, Carry set - TURBO
//

// XXX implement fallback to autodetection, correct screen color for NORMAL


#if CONFIG_TAPE_NORMAL && CONFIG_TAPE_TURBO && CONFIG_TAPE_AUTODETECT


tape_common_autodetect:

	// Set screen color to something neutral, silence the audio
	lda #$0B
	sta VIC_EXTCOL
	lda #$00
	sta SID_SIGVOL

	// FALLTROUGH

tape_common_autodetect_retry:

	// It is not trivial to distinguish between NORMAL and TURBO,
	// as short pulses of NORMAL (and sync uses only shorts)
    // have similar lengths as long pulses of TURBO

	// Thus, the routine here reads certain amount of pulses
	// looking for evidence for either NORMAL or TURBO system;
	// in case of no evidence found, assume NORMAL

	lda #$00                           // plus = probably NORMAL, minus = TURBO
	sta XSAV

	ldy #$60                           // $60 pulses cover 12 bytes of TURBO recording
	jsr tape_normal_get_pulse          // first pulse might be a garbage, ignore it

	// FALLTROUGH

tape_common_autodetect_loop:

	jsr tape_normal_get_pulse          // read pulse for detection attempt
	
	// If garbage found, retry detection
	cmp #$28
	bcc tape_common_autodetect_retry   // this is a VERY long pulse
	cmp #$E8
	bcs tape_common_autodetect_retry   // this is a VERY short pulse

	// First try to distinguish TURBO short signal (reference: $CD)
	// from NORMAL signals (reference: $A5 or lower), these values
	// give us threshold of ($CD + $A5) / 2 = $B9

	cmp #$B9
	bcc !+
	dec XSAV                           // above $B9 (so signal is shorter), looks like TURBO 
!:
	// Now try to distinguish TURBO signals (reference: $B1 or higher)
	// from NORMAL medium/long signals (reference: $7D or below), these values
	// give us threshold of ($B1 + $7D) / 2 = $97

	cmp #$97
	bcs !+
	inc XSAV
!:
	// The sync for TURBO is not too long - if we have enough evidence,
	// assume TURBO recording already

	lda XSAV
	cmp #$FD
	beq tape_common_autodetect_turbo

	// Next iteration
	dey
	bpl tape_common_autodetect_loop

	// Last chance for TURBO

	lda XSAV
	bmi tape_common_autodetect_turbo

	// FALLTROUGH

tape_common_autodetect_normal:

	clc
	rts

tape_common_autodetect_turbo:

	sec
	rts


#endif
