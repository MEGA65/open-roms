
//
// Official Kernal routine, described in:
//
// - [RG64] C64 Programmer's Reference Guide   - page 303
// - [CM64] Compute's Mapping the Commodore 64 - pages 27, 232
//
// CPU registers that has to be preserved (see [RG64]): .Y
//

UDTIM:

	// Update jiffy clock. The whole day is $4F1A00 jiffies
	// (24 hours * 60 minutes * 60 seconds * 60 jiffies),
	// after this time we have to reset the clock.

	inc TIME+0
	bne udtim_time_done   // done with clock
	inc TIME+1
	bne udtim_clock_rollover
	inc TIME+2

	// FALLTROUGH

udtim_time_done:

	jmp udtim_keyboard

udtim_clock_rollover:

	// At this point TIME+0 contains 0
	lda TIME+1
	cmp #$1A
	bne udtim_time_done   // done with clock
	lda TIME+2
	cmp #$4F
	bne udtim_time_done   // done with clock
	lda #$00
	sta TIME+2
	sta TIME+1
	beq udtim_time_done   // done with clock - will always jump
