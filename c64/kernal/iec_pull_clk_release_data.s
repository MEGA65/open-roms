
iec_pull_clk_release_data:
	lda CI2PRA
	ora #BIT_CI2PRA_CLK_OUT          ; pull
	and #$FF - BIT_CI2PRA_DAT_OUT    ; release
	sta CI2PRA
	rts
