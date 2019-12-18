
//
// Tape (turbo) helper routine - byte reading
//
// Returns byte in .A
//


#if CONFIG_TAPE_NORMAL


tape_normal_get_byte:

	lda #$0B
	sta VIC_EXTCOL

	// First we need a byte marker - (L,M)

!:
	jsr tape_normal_get_pulse
	cmp #($100 - $95 - $05)
	bcs !-                             // too short for a long pulse
	jsr tape_normal_get_pulse
	bcs !-                             // too short for a medium pulse

	// Now fetch individual bits

	// XXX finish this

	jsr tape_normal_get_bit
	jsr tape_normal_get_bit
	jsr tape_normal_get_bit
	jsr tape_normal_get_bit
	jsr tape_normal_get_bit
	jsr tape_normal_get_bit
	jsr tape_normal_get_bit
	jsr tape_normal_get_bit








	rts


#endif
