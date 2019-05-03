iec_release_atn:
	lda $dd00
	and #$f7
	sta $dd0
	rts
