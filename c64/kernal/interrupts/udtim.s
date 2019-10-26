
//
// Official Kernal routine, described in:
//
// - [RG64] C64 Programmer's Reference Guide   - page 303
// - [CM64] Compute's Mapping the Commodore 64 - pages 27, 232
//
// CPU registers that has to be preserved (see [RG64]): .Y
//

UDTIM:

	// Update jiffy clock. The whole day is $4F1A00 jiffies (24 hours * 60 minutes * 60 seconds * 60 jiffies),
	// after this time we have to reset the clock.

	inc TIME+0
	bne udtim_update_stkey   // done with clock
	inc TIME+1
	bne udtim_clock_rollover
	inc TIME+2

	// FALLTROUGH

udtim_update_stkey: // entry to be used when interrupts are disabled

	// According to [CM64], page 27, another action we have to perform is to copy
	// the last row of keyboard to RAM, so that various routines can detect the STOP
	// key press. But something as simple as this would have created warm restart
	// with M+N+SPACE+RESTORE due to ghosting - so the original ROM has to provide
	// some protection here. I do not know what the mechanism there exactly does,
	// but I hope the mechanism below will be compatible enough.

	lda #$80
	sta CIA1_PRA             // select all the rows except the last one
#if CONFIG_KEYBOARD_C128
	ldx #$00
	stx VIC_XSCAN            // connect all the extra C128 keys
#endif
#if CONFIG_KEYBOARD_C65
	ldx #$00
	stx C65_EXTKEYS_PR       // connect all the extra C65 keys
#endif

	lda CIA1_PRB             // read the keys
	eor #$FF
	sta STKEY                // store reversed state - to filter out anything vulnerable to ghosting

#if CONFIG_KEYBOARD_C128
	dex                      // puts $FF
	stx VIC_XSCAN            // disconnect the extra C128 keys
#endif
#if CONFIG_KEYBOARD_C65
	dex                      // puts $FF
	stx C65_EXTKEYS_PR       // disconnect the extra C65 keys
#endif
	lda #$7F
	sta CIA1_PRA             // select the last row (bit to 0)

	lda CIA1_PRB             // read the row
	ora STKEY                // filter out what might be the reason of ghosting
	sta STKEY

	// Leave the CIA configured this way. It would be far better to disconnect
	// the keyboard at this point, but certain software (mainly intros) is
	// unable to, for example, read the space bar status.

	rts

udtim_clock_rollover:

	// At this point TIME+0 contains 0
	lda TIME+1
	cmp #$1A
	bne udtim_update_stkey   // done with clock
	lda TIME+2
	cmp #$4F
	bne udtim_update_stkey   // done with clock
	lda #$00
	sta TIME+2
	sta TIME+1
	beq udtim_update_stkey   // done with clock - will always jump
