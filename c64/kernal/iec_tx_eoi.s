
iec_tx_eoi:

	;; Wait at least 200us
	jsr iec_wait100us
	jsr iec_wait100us

	;; Restore the bus to idle state
	jsr iec_set_idle

	rts
