// #LAYOUT# STD *        #TAKE
// #LAYOUT# M65 KERNAL_1 #TAKE
// #LAYOUT# *   *        #IGNORE

//
// Check if VERIFY asked - if yes, terminate loading
//


#if CONFIG_TAPE_NORMAL || CONFIG_TAPE_TURBO


tape_ditch_verify:

	lda VERCKK
	bne !+
	rts
!:
	pla
	pla
	jmp lvs_device_not_found_error


#endif
