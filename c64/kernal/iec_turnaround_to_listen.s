	;; 	According to http://www.zimmers.net/anonftp/pub/cbm/programming/serial-bus.pdf
	;;  	pages 7--8.
	;; See also https://www.pagetable.com/?p=1135, https://github.com/mist64/cbmbus_doc

iec_turnaround_to_listen:

	;; Pull DATA, release CLK and ATN (we are not sending commands)
	jsr iec_pull_data_release_atn_clock

	;; Wait for clock line to be pulled by the drive
	ldx #$FF ; XXX should we really use that high number?
*
	lda CI2PRA
	rol    ; to put BIT_CI2PRA_CLK_IN as the last (sign) bit 
	bpl +
	dex
	bne -

	;; Timeout
	jsr printf
	.byte "DBG: TURNAROUND FAILED",$0d,$00
	sec
	rts

	;; CLK is pulled by the device, OK
*	
	clc
	rts

