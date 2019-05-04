iec_release_atn:
	jsr printf
	.byte "RELEASE ATN",$0d,0
	lda $dd00
	and #$f7
	sta $dd00
	rts
