// #LAYOUT# STD *        #TAKE
// #LAYOUT# *   KERNAL_0 #TAKE
// #LAYOUT# *   *        #IGNORE

//
// Helper routine for JiffyDOS detection
//

// Detection is done by inserting a long delay (above 400us?) during sending command last bit, see:
// - https://sites.google.com/site/h2obsession/CBM/C128/JiffySoft128
// - https://github.com/rkrajnc/sd2iec/blob/master/src/iec.c
// The 'iec.s' suggests, that the drive should respond by pulling data

// The original JiffyDOS ROM seems to perform detection with every command
// (even though for many of them it always fails) and we have to replicate
// this behaviour for compatibility with at least 1541 JiffyDOS ROM


#if CONFIG_IEC_JIFFYDOS


jiffydos_detect:

    ldy #$25                           // 400us is nearly 410 cycles on NTSC
                                       // loop iteration below is 11 cycles,
                                       // and several cycles were already used
jiffydos_detect_loop:
	lda CIA2_PRA                       // 4 cycles
	bpl jiffydos_detected              // 2 cycles
	dey                                // 2 cycles
	bne jiffydos_detect_loop           // 3 cycles if branch

	lda IECPROTO
	bpl jiffydos_detect_end            // no detection requested, preserve existing protocol

	lda #$00                           // normal protocol
	beq jiffydos_store_proto           // branch always

jiffydos_detected:
	jsr iec_wait_for_data_release      // guessed from VICE logs
	lda #$01                           // JiffyDOS protocol

	// FALLTROUGH

jiffydos_store_proto:
	sta IECPROTO

	// FALLTROUGH

jiffydos_detect_end:
	rts


#endif // CONFIG_IEC_JIFFYDOS
