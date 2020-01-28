// #LAYOUT# M65 KERNAL_0 #TAKE
// #LAYOUT# *   *        #IGNORE

//
// Tape (normal) helper routine - byte storage when ban changing is needed
//


#if CONFIG_TAPE_NORMAL


tape_normal_byte_store:

	jsr map_NORMAL
	sta (MEMUSS), y
	jmp map_KERNAL_1


#endif
