
iec_wait20us:	
	;; Wait 20usec
	;; JSR + RTS already costs 12, so need only 8 more
	ldy $dd00
	ldy $dd00
	rts
