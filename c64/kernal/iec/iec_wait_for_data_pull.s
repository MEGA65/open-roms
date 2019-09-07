
iec_wait_for_data_pull:

	lda CIA2_PRA
	// Check the highest bit, which is DATA IN,
	// (highest bit set = negative value)
	bmi iec_wait_for_data_pull
	rts
