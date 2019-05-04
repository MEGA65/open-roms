iec_wait_for_data_release:
	LDA $DD00
	and #$40
	beq iec_wait_for_data_release
	rts
