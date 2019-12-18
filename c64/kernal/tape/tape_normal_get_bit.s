
//
// Tape (turbo) helper routine - bit reading
//
// Returns bit in Zero flag, Carry set means error, on 0 bit .A is 0 too
//


#if CONFIG_TAPE_NORMAL


tape_normal_get_bit:

	// Fetch the first pulse

	jsr tape_normal_get_pulse
	bcc tape_normal_get_bit_0

	// First impulse was short, second should be long

	jsr tape_normal_get_pulse
	bcs tape_normal_get_bit_error

	// We have a bit '1'

	// Carry flag already clear
	lda #$06

	// FALLTROUGH

tape_normal_get_bit_done:

	sta VIC_EXTCOL
	rts


tape_normal_get_bit_0:

	// First impulse was long, second should be short

	jsr tape_normal_get_pulse
	bcc tape_normal_get_bit_error

	// We have a bit '0'

	clc
	lda #$00
	beq tape_normal_get_bit_done       // branch always


tape_normal_get_bit_error:
	sec
	rts


#endif // CONFIG_TAPE_NORMAL
