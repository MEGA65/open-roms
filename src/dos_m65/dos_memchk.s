
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

	clc 
	rts

@fail:

	sec
	rts
