
iec_wait_for_clk_pull:
	lda CI2PRA
	rol    ; to put BIT_CI2PRA_CLK_IN as the last (sign) bit 
	bmi iec_wait_for_clk_pull
	rts
