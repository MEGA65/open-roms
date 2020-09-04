// #LAYOUT# M65 KERNAL_0 #TAKE
// #LAYOUT# *   *        #IGNORE

//
// MEGA65 pseudo-IEC internal DOS support - detect if a drive should be handled by internal DOS
//


m65dos_detect:

	// Checks if drive is supported by internal DOS
	// Output: Carry set if not supported, if supported IECPROTO isset to IEC_ROMDOS

	pha
	jsr m65dos_chkunit
	bcs !+

	lda #IEC_ROMDOS
	sta IECPROTO
!:
	pla
	rts
