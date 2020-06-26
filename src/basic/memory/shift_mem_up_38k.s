// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE


#if CONFIG_MEMORY_MODEL_38K

shift_mem_up:

	// Move __memmove_size bytes from __memmove_src to __memmove_dst,
	// where __memmove_dst > __memmove_src
	// This means we have to copy from the back end down.
	// This routine assumes the pointers are already pointed
	// to the end of the areas, and that Y is correctly initialised
	// to allow the copy to begin.

	php
!:	
	lda (__memmove_src),y
	sta (__memmove_dst),y
	dey
	bne !-
	dec __memmove_src+1
	dec __memmove_dst+1
	dec __memmove_size+1
	bne !-
	plp
	rts

#endif
