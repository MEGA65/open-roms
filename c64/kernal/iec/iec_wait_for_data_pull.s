#if ROM_LAYOUT_STD || (ROM_LAYOUT_M65 && SEGMENT_KERNAL_0)


#if CONFIG_IEC


iec_wait_for_data_pull:

	lda CIA2_PRA
	// Check the highest bit, which is DATA IN,
	// (highest bit set = negative value)
	bmi iec_wait_for_data_pull
	rts


#endif // CONFIG_IEC


#endif // ROM layout
