// #LAYOUT# M65 KERNAL_0 #TAKE
// #LAYOUT# *   *        #IGNORE


M65_ISMODE65: // checks if mode is native M65 one, BCC = jump if native mode

	pha

	lda M65_MAGICSTR+0
	cmp #$4D // 'M'
	bne !+
	lda M65_MAGICSTR+1
	cmp #$36 // '6'
	bne !+
	lda M65_MAGICSTR+2
	cmp #$35 // '5'
	bne !+

	// M65 native mode

	clc
	pla
	rts
!:
	// C64 compatibility mode

	sec
	pla
	rts
