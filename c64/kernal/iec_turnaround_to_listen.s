	;; 	According to http://www.zimmers.net/anonftp/pub/cbm/programming/serial-bus.pdf
	;;  	pages 7--8.
	
iec_turnaround_to_listen:

	jsr printf
	.byte "DOING TURNAROUND",$0d,0
	
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

	;;  Wait for clk to be released by the drive to mark ready to talk
	ldx #$ff
*	lda $dd00
	and #$40
	bne +
	dex
	beq -

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
	cli
	rts
