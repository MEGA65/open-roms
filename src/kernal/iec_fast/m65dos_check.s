// #LAYOUT# M65 KERNAL_0 #TAKE
// #LAYOUT# *   *        #IGNORE

//
// MEGA65 pseudo-IEC internal DOS support - check if the current device is already handled by internal DOS
//


m65dos_check:

	pha
	lda IECPROTO
	cmp #IEC_ROMDOS
	beq !+

	pla
	sec
	rts
!:
	pla
	clc
	rts
