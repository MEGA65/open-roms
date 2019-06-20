
iec_set_idle:
	lda CI2PRA
	ora #BIT_CI2PRA_CLK_OUT                               ; pull
	and #$FF - BIT_CI2PRA_DAT_OUT - BIT_CI2PRA_ATN_OUT    ; release
	sta CI2PRA
	rts
