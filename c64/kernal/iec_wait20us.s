
iec_wait20us:	
	;; Wait 20usec
	;; JSR + RTS already costs 12, so need only 8 more
	ldx $dd00
	ldx $dd00
	rts
