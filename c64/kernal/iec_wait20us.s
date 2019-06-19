
iec_wait20us:	
	;; Wait 20usec
	;; JSR + RTS already costs 12, so need only 8 more
	ldy $dd01 ; reading dd00 makes debugging harder
	ldy $dd01
	rts
