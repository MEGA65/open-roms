
; Handling shadow memory, preserves .P



util_shadow:

	ldx #$00
@1:
	ldy MEM_BUF, x
	sty MEMSHADOW_BUF, x
	inx
	bne @1

	rts

util_shadow_restore:

	php

	ldx #$00
@1:
	ldy MEMSHADOW_BUF, x
	sty MEM_BUF, x
	inx
	bne @1

	bne @1

	plp
	rts
