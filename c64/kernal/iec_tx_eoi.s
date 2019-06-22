
iec_tx_eoi:

	;; Releasing ATN needed due to current iec_tx_command implementation
	jsr iec_release_atn

	;; Wait at least 256 usec
	jsr iec_wait100us
	jsr iec_wait100us
	jsr iec_wait60us

	;; Restore the bus to idle state
	jsr iec_set_idle

	rts
