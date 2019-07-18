	;; 	According to http://www.zimmers.net/anonftp/pub/cbm/programming/serial-bus.pdf
	;;  	pages 7--8.
	;; See also https://www.pagetable.com/?p=1135, https://github.com/mist64/cbmbus_doc

iec_turnaround_to_listen:

	;; Timing is critical here - execute on disabled IRQs
	php
	sei

	;; Pull DATA, release CLK and ATN (we are not sending commands)
	jsr iec_pull_data_release_atn_clk

	;; Wait for clock line to be pulled by the drive
	ldx #$FF ; XXX should we really use that high number?
*
	lda CIA2_PRA
	rol    ; to put BIT_CIA2_PRA_CLK_IN as the last (sign) bit 
	bpl +
	dex
	bne -

	;; Timeout
	plp
	sec
	rts

	;; CLK is pulled by the device, OK
*
	plp
	clc
	rts

