// #LAYOUT# STD *        #TAKE
// #LAYOUT# *   KERNAL_0 #TAKE
// #LAYOUT# *   *        #IGNORE

//
// Official Kernal routine, described in:
//
// - [RG64] C64 Programmers Reference Guide   - page 303
// - [CM64] Computes Mapping the Commodore 64 - pages 27, 232
//
// CPU registers that has to be preserved (see [RG64]): .Y
//

UDTIM:

	// Update jiffy clock. The whole day is $4F1A00 jiffies
	// (24 hours * 60 minutes * 60 seconds * 60 jiffies),
	// after this time we have to reset the clock.

	inc TIME+2
	bne udtim_rollover_check
	inc TIME+1
	bne udtim_rollover_check
	inc TIME+0

	// FALLTROUGH

udtim_rollover_check:

	lda TIME+0
	cmp #$4F
	bcc udtim_time_done
	lda TIME+1
	cmp #$1A	
	bcc udtim_time_done
	
	// FALLTROUGH

udtim_clock_reset:

	lda #$00
	sta TIME+0
	sta TIME+1
	sta TIME+2

	// FALLTROUGH

udtim_time_done:

	jmp udtim_keyboard
