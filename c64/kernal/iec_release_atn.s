
iec_release_atn:

	lda CIA2_PRA
	and #$FF - BIT_CIA2_PRA_ATN_OUT    ; release
	sta CIA2_PRA
	rts

