
;
; Check if DOS memory is not overwritten
;


dos_MEMCHK:

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

	lda #$60
	cmp code_RTS_01
	bne @fail
	cmp code_RTS_02
	bne @fail
	cmp code_RTS_03
	bne @fail

	clc 
	rts

@fail:

	sec
	rts
