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
	and #$40
	bne -

	ldx #$ff
*	lda $dd00
	and #$40
	bne +
	dex
	bne -

	jsr printf
	.byte "TURNAROUND FAILED - FILE NOT FOUND?",$0d,$00
	
	;; Timeout = file not found error
	;; (https://www.pagetable.com/?p=1023)
	lda #4
	sec
	rts
*
	jsr printf
	.byte "TURNAROUND SUCEEDED",$0d,$00

	;; ATN turn around successful
	clc
	rts
