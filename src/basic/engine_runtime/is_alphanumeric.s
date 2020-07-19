// #LAYOUT# STD *       #TAKE
// #LAYOUT# M65 BASIC_1 #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE

//
// Check .A content, if within 0-9, A-Z ranges, sets Carry if check fails
//


is_09_AZ:

	jsr is_AZ
	bcs is_09
	rts


is_09:

	cmp #$30                                 // if below '0' - check failed
	bcc is_alphanumeric_fail

	cmp #$3A                                 // if above '9' - check failed
	rts


is_AZ:

	cmp #$41                                 // if below 'A' - check failed
	bcc is_alphanumeric_fail

	cmp #$7B                                 // if above 'Z' - check failed
	rts


is_alphanumeric_fail:

	sec
	rts
