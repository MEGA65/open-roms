;; #LAYOUT# M65 KERNAL_0 #TAKE
;; #LAYOUT# *   *        #IGNORE


M65_MODEGET:

	; Checks if mode is native M65 one; Carry clear = native mode, Carry set = legacy mode

	pha

	lda M65_MAGICSTR+0
	cmp #$4D ; 'M'
	bne @1
	lda M65_MAGICSTR+1
	cmp #$36 ; '6'
	bne @1
	lda M65_MAGICSTR+2
	cmp #$35 ; '5'
	bne @1

	; M65 native mode

	clc
	pla
	rts
@1:
	; C64 compatibility mode

	sec
	pla
	rts
