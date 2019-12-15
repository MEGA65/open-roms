
//
// IEC part of the CHROUT routine
//


chrout_iec:

	lda SCHAR
	jsr JCIOUT
	bcc_far chrout_done_success
	jmp chrout_done_fail
