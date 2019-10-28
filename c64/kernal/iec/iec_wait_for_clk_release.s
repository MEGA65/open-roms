

#if CONFIG_IEC


iec_wait_for_clk_release:

	lda CIA2_PRA
	and #BIT_CIA2_PRA_CLK_IN
	beq iec_wait_for_clk_release
	rts


#endif // CONFIG_IEC
