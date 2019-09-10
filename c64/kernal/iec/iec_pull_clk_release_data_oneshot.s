
iec_pull_clk_release_data_oneshot:

	lda CIA2_PRA
	ora #BIT_CIA2_PRA_CLK_OUT          // pull
	and #$FF - BIT_CIA2_PRA_DAT_OUT    // release
	sta CIA2_PRA
	rts
