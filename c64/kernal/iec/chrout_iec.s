#if ROM_LAYOUT_STD || (ROM_LAYOUT_M65 && SEGMENT_KERNAL_0)

//
// IEC part of the CHROUT routine
//


chrout_iec:

	lda SCHAR
	jsr JCIOUT
	bcc_16 chrout_done_success
	jmp chrout_done_fail


#endif // ROM layout
