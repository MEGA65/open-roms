#if ROM_LAYOUT_STD || (ROM_LAYOUT_M65 && SEGMENT_KERNAL_0)

//
// IEC part of the CKOUT routine
//


#if CONFIG_IEC


ckout_iec:

	// Fail if the file is open for reading (secondary address 0)
	
	lda LAT, Y
	beq_far ckout_file_not_output

	// Send LISTEN + SECOND first
	lda FAT,Y

	jsr LISTEN
	bcs_far chkinout_device_not_present

	lda LAT, Y
	ora #$60
	jsr SECOND
	bcs_far chkinout_device_not_present

	jmp ckout_set_device


#endif // CONFIG_IEC


#endif // ROM layout
