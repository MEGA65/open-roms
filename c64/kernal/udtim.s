
//
// Official Kernal routine, described in:
//
// - [RG64] C64 Programmer's Reference Guide   - page 303
// - [CM64] Compute's Mapping the Commodore 64 - page 232
//
// CPU registers that has to be preserved (see [RG64]): .Y
//

UDTIM:

	// Update jiffy clock. The whole day is $4F1A00 jiffies (24 hours * 60 minutes * 60 seconds * 60 jiffies),
	// after this time we have to reset the clock.

	inc TIME+0
	bne udtim_update_stkey // done with clock
	inc TIME+1
	bne udtim_clock_rollover
	inc TIME+2

	// FALLTROUGH

udtim_update_stkey: // entry to be used when interrupts are disabled

	// Another action we have to perform is to copy the last row of keyboard to RAM,
	// so that various routines can detect the STOP key press
	// XXX scnkey contains similar sequence - deduplicate this!
	lda #$FF
	sta CIA1_DDRA // output
	lda #$00
	sta CIA1_DDRB // input

	lda #$7F
	sta CIA1_PRA  // select the last row (bit to 0)

	lda CIA1_PRB  // read the row
	sta STKEY
	rts

udtim_clock_rollover:

	// At this point TIME+0 contains 0
	lda TIME+1
	cmp #$1A
	bne udtim_update_stkey // done with clock
	lda TIME+2
	cmp #$4F
	bne udtim_update_stkey // done with clock
	lda #$00
	sta TIME+2
	sta TIME+1
	beq udtim_update_stkey // done with clock - will always jump
