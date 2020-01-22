// #LAYOUT# STD *        #TAKE
// #LAYOUT# *   KERNAL_0 #TAKE
// #LAYOUT# *   *        #IGNORE

//
// Tape (normal) helper routine - checksum calculation
//


#if CONFIG_TAPE_NORMAL


tape_normal_update_checksum:

	lda INBIT
	eor RIPRTY
	sta RIPRTY

	rts


#endif
