
;
; Helper code for debugging the monitor
;

; XXX remove this code once the monitor integration is complete

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
