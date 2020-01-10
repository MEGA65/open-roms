#if ROM_LAYOUT_STD || (ROM_LAYOUT_M65 && SEGMENT_KERNAL_0)

//
// IEC part of the CHKIN routine
//


#if CONFIG_IEC


chkin_iec:

	// Fail if the file is open for writing (secondary address 1)
	
	lda LAT, Y
	cmp #$01
	beq_far chkin_file_not_input

	// Send TALK + TKSA first
	lda FAT,Y
	
	jsr TALK
	bcs_far chkinout_device_not_present

	lda LAT, Y
	ora #$60
	jsr TKSA
	bcs_far chkinout_device_not_present

	jmp chkin_set_device

#endif // CONFIG_IEC


#endif // ROM layout
