#if ROM_LAYOUT_STD || (ROM_LAYOUT_M65 && SEGMENT_KERNAL_0)


#if CONFIG_IEC


iec_wait_for_clk_release:

	bit CIA2_PRA
	bvc iec_wait_for_clk_release
	rts


#endif // CONFIG_IEC


#endif // ROM layout
