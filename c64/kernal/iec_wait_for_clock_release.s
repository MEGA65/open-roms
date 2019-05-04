iec_wait_for_clock_release:
	LDA $DD00
	and #$40
	beq iec_wait_for_clock_release
	rts
