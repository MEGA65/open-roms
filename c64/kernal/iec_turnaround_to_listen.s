	;; 	According to http://www.zimmers.net/anonftp/pub/cbm/programming/serial-bus.pdf
	;;  	pages 7--8.
	
iec_turnaround_to_listen:
	;; Assert data and release clock
	lda $dd00
	sta $0420
	and #$ef		; release clock (bit 4)
	ora #$20     		; assert data (bit 5)
	sta $dd00

	;; Wait for clock line to be asserted by the drive
*	lda $dd00
	sta $0421
	and #$80
	bne -
	
	rts
	
