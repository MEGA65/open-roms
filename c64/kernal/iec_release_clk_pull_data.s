
iec_release_clk_pull_data:
	lda CI2PRA
	and #$FF - BIT_CI2PRA_CLK_OUT    ; release
	ora #BIT_CI2PRA_DAT_OUT          ; pull
	sta CI2PRA
	rts
