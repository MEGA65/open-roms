
; Helper routines for entering/exiting the context



dos_ENTER:         ; enter DOS context
 
	php
	jsr m65_speed_tape_cbdos
	plp

	sta REG_A
	stx REG_X
	sty REG_Y
	stz REG_Z

	rts


dos_EXIT_SEC:      ; exit DOS context with Carry set

	sec
	bra dos_EXIT_common

dos_EXIT:          ; exit DOS context with Carry clear

	clc

	; FALLTROUGH

dos_EXIT_common:

	lda REG_A
	bra dos_EXIT_A_common


dos_EXIT_A_SEC:    ; exit DOS context with Carry set, return .A

	sec
	bra dos_EXIT_A_common

dos_EXIT_A:        ; exit DOS context with Carry clear, return .A

	clc

	; FALLTROUGH

dos_EXIT_A_common:

	ldz REG_Z
	ldy REG_Y
	ldx REG_X

	php
	jsr m65_speed_restore
	plp

	rts
