
;
; Check if DOS memory is not overwritten
;


dos_MEMCHK:

	pha
	phx

	; Check for magic string

	ldx #$04
@1:
	lda MAGICSTR, x
	cmp dos_magicstr, x
	bne @fail
	dex
	bpl @1

	; Check if helper code is undamaged

	lda #$AD
	cmp code_LDA_01
	bne @fail
	cmp code_LDA_02
	bne @fail
	cmp code_LDA_03
	bne @fail
	cmp code_LDA_04
	bne @fail

	lda #$60
	cmp code_RTS_01
	bne @fail
	cmp code_RTS_02
	bne @fail
	cmp code_RTS_03
	bne @fail
	cmp code_RTS_04
	bne @fail
	cmp code_RTS_05
	bne @fail

	plx
	pla
	clc 
	rts

@fail:

	plx
	pla
	sec
	rts
