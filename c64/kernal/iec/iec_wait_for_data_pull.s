// #LAYOUT# STD *        #TAKE
// #LAYOUT# *   KERNAL_0 #TAKE
// #LAYOUT# *   *        #IGNORE


#if CONFIG_IEC


iec_wait_for_data_pull:

	lda CIA2_PRA
	// Check the highest bit, which is DATA IN,
	// (highest bit set = negative value)
	bmi iec_wait_for_data_pull
	rts


#endif // CONFIG_IEC
