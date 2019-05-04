iec_wait_for_clock_release:
	LDA $DD00
	and #$80
	beq iec_wait_for_clock_release
	rts
