
;
; Z80 indez register helpers
;

; XXX find a way to optimize them (inline? helper table?)


Z80_common_fetch_via_IX_d:

	lda REG_IX+1
	sta PTR_DATA+1
	lda REG_IX+0
	bmi @1
	dec PTR_DATA+1
@1:
	eor #%10000000
	sta PTR_DATA+0

	+Z80_FETCH_VIA_PC_INC
	tax
	lda z80_otable_displacement,x
	clc
	adc PTR_DATA+0
	sta PTR_DATA+0
	bcc @2
	inc PTR_DATA+1
@2:
	lda [PTR_DATA], z

	rts


Z80_common_fetch_via_IY_d:

	lda REG_IY+1
	sta PTR_DATA+1
	lda REG_IY+0
	bmi @1
	dec PTR_DATA+1
@1:
	eor #%10000000
	sta PTR_DATA+0

	+Z80_FETCH_VIA_PC_INC
	tax
	lda z80_otable_displacement,x
	clc
	adc PTR_DATA+0
	sta PTR_DATA+0
	bcc @2
	inc PTR_DATA+1
@2:
	lda [PTR_DATA], z

	rts

Z80_common_store_via_IX_d:

	lda REG_IX+1
	sta PTR_DATA+1
	lda REG_IX+0
	bmi @1
	dec PTR_DATA+1
@1:
	eor #%10000000
	sta PTR_DATA+0

	+Z80_FETCH_VIA_PC_INC
	tax
	lda z80_otable_displacement,x
	clc
	adc PTR_DATA+0
	sta PTR_DATA+0
	bcc @2
	inc PTR_DATA+1
@2:
	txa
	sta [PTR_DATA], z

	rts


Z80_common_store_via_IY_d:

	lda REG_IY+1
	sta PTR_DATA+1
	lda REG_IY+0
	bmi @1
	dec PTR_DATA+1
@1:
	eor #%10000000
	sta PTR_DATA+0

	+Z80_FETCH_VIA_PC_INC
	tax
	lda z80_otable_displacement,x
	clc
	adc PTR_DATA+0
	sta PTR_DATA+0
	bcc @2
	inc PTR_DATA+1
@2:
	txa
	sta [PTR_DATA], z

	rts