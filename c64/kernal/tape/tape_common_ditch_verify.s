// #LAYOUT# STD *        #TAKE
// #LAYOUT# *   KERNAL_0 #TAKE
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
