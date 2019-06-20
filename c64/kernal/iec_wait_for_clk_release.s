
iec_wait_for_clk_release:
	lda CI2PRA
	and #BIT_CI2PRA_CLK_IN
	beq iec_wait_for_clk_release
	rts
