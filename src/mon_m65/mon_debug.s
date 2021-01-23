
;
; Helper code for debugging the monitor
;

; XXX disable this code once the monitor integration is complete

DBG_print_Buf_Index:

	php
	pha
	phx
	phy
	phz

	lda #':'
	jsr CHROUT

	lda Buf_Index
	jsr Print_Hex

	plz
	ply
	plx
	pla
	plp

	rts


DBG_print_char:

	php
	pha
	phx
	phy
	phz

	jsr CHROUT

	plz
	ply
	plx
	pla
	plp

	rts


DBG_print_long_ac:

	php
	pha
	phx
	phy
	phz

	lda #'*'
	jsr CHROUT

	lda Dig_Cnt
	jsr Print_Hex

	lda #'*'
	jsr CHROUT

	lda Long_AC+3
	jsr Print_Hex
	lda Long_AC+2
	jsr Print_Hex
	lda Long_AC+1
	jsr Print_Hex
	lda Long_AC+0
	jsr Print_Hex

	plz
	ply
	plx
	pla
	plp

	rts
