
iec_release_atn_clk_data:
	lda CI2PRA
	and #$FF - BIT_CI2PRA_ATN_OUT - BIT_CI2PRA_CLK_OUT - BIT_CI2PRA_DAT_OUT    ; release
	sta CI2PRA
	rts

