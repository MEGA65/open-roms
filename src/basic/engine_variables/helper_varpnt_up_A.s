// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE

//
// Helper routine, used by various variable-related routines
//


helper_VARPNT_up_A:                  // .A - bytes to increment VARPNT

	clc
	adc VARPNT+0
	sta VARPNT+0
	bcc !+
	inc VARPNT+1
!:
	rts
