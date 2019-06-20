
iec_pull_data_release_atn_clock:
	lda CI2PRA
	ora #BIT_CI2PRA_DAT_OUT                              ; pull
	and #$FF - BIT_CI2PRA_ATN_OUT - BIT_CI2PRA_CLK_OUT   ; release
	sta CI2PRA
	rts
