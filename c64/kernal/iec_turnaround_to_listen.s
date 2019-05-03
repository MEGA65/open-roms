	;; 	According to http://www.zimmers.net/anonftp/pub/cbm/programming/serial-bus.pdf
	;;  	pages 7--8.
	
iec_turnaround_to_listen:
	;; Assert data and release clock
	lda $dd00
	and #$ef
	ora #$08
	sta $dd00

	;; Wait for clock line to be asserted by the drive
*	lda $dd00
	and #$10
	beq -
	
	rts
	
