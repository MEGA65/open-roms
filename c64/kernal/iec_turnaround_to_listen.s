	;; 	According to http://www.zimmers.net/anonftp/pub/cbm/programming/serial-bus.pdf
	;;  	pages 7--8.
	
iec_turnaround_to_listen:

	;; Assert data and release clock
	lda $dd00
	and #$ef		; release clock (bit 4)
	ora #$20     		; assert data (bit 5)
	sta $dd00
	
	;; Wait for clock line to be asserted by the drive
*	lda $dd00
	and #$40
	bne -

	;; http://www.zimmers.net/anonftp/pub/cbm/programming/serial-bus.pdf
	;; page 8 tells us we should not do anything here after waiting for
	;; the clock line to assert.
	
;; 	ldx #$ff
;; *	lda $dd00
;; 	and #$40
;; 	bne +
;; 	dex
;; 	bne -

	;; jsr printf
	;; .byte "TURNAROUND FAILED - FILE NOT FOUND?",$0d,$00
	
	;; ;; Timeout = file not found error
	;; ;; (https://www.pagetable.com/?p=1023)
	;; lda #4
	;; sec
	;; rts
*

	;; ATN turn around successful
	clc
	rts
