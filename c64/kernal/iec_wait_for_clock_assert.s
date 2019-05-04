iec_wait_for_clock_assert:
	LDA $DD00
	and #$80
	bne iec_wait_for_clock_assert
	rts
