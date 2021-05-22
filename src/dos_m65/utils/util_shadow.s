
; Handling shadow memory, preserves .P



util_shadow:

	ldx #$00
@1:
	ldy $1000, x
	sty MEMSHADOW_BUF, x
	inx
	bne @1

	rts

util_shadow_restore:

	php

	ldx #$00
@1:
	ldy MEMSHADOW_BUF, x
	sty $1000, x
	inx
	bne @1

	bne @1

	plp
	rts
