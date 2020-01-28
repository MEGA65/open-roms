// #LAYOUT# M65 KERNAL_0 #TAKE
// #LAYOUT# *   *        #IGNORE

//
// Tape (turbo) helper routine - byte storage when ban changing is needed
//


#if CONFIG_TAPE_TURBO


tape_turbo_byte_store:

	jsr map_NORMAL
	jsr __tape_turbo_bytestore         // like 'sta (MEMUSS),y' - but under I/O
	jmp map_KERNAL_1


#endif
