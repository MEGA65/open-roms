	;; 	According to http://www.zimmers.net/anonftp/pub/cbm/programming/serial-bus.pdf
	;;  	pages 7--8.
	
iec_turnaround_to_listen:
	;; Assert data and release clock
	lda $dd00
	sta $0420
	and #$ef		; release clock (bit 4)
	ora #$20     		; assert data (bit 5)
	sta $dd00

	;; Make sure we actually see CLK release?
	;; This could cause the CLK assertion by the talker to be missed,
	;; so shouldn't probably be done. But it is an attempt to debug
	;; why we never see CLK release after the turn-around.
	jsr iec_wait_for_clock_release
	
	;; Wait for clock line to be asserted by the drive
*	lda $dd00
	sta $0421
	and #$80
	bne -
	
	rts
	
