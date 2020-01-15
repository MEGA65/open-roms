// #LAYOUT# STD *        #TAKE
// #LAYOUT# *   KERNAL_0 #TAKE
// #LAYOUT# *   *        #IGNORE


#if CONFIG_IEC


iec_wait_for_clk_release:

	bit CIA2_PRA
	bvc iec_wait_for_clk_release
	rts


#endif // CONFIG_IEC
