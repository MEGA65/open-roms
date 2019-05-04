iec_assert_atn:
	jsr printf
	.byte "ASSERT ATN",$0d,0
	lda $dd00
	ora #$08
	sta $dd00
	rts
