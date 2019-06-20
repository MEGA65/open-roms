
iec_pull_atn_clk_release_data:
	lda CI2PRA
	ora #BIT_CI2PRA_ATN_OUT + BIT_CI2PRA_CLK_OUT    ; pull
	and #$FF - BIT_CI2PRA_DAT_OUT                   ; release
	sta CI2PRA
	rts
