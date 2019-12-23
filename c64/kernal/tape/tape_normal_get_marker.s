
//
// Tape (normal) helper routine - marker reading
//
// Reeturns marker type in Carry flag, set = end of data
//

tape_normal_get_marker:

	// (L,M) - end of byte, (L,S) - end of data

	jsr tape_normal_get_pulse
	cmp #($FF - $98 - $04)
	bcs tape_normal_get_marker                             // too short for a long pulse

	jmp tape_normal_get_pulse
