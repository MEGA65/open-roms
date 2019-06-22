
iec_release_atn:

	lda CI2PRA
	and #$FF - BIT_CI2PRA_ATN_OUT    ; release
	sta CI2PRA
	rts

