// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE


#if CONFIG_MEMORY_MODEL_38K

shift_mem_down:

	// Move memmove__size bytes from memmove__src to memmove__dst, where memmove__dst > memmove__src
	//
	// This means we have to copy from the back end down.
	// This routine assumes the pointers are already pointed to the end of the areas, and that .Y is correctly initialized

	php
!:
	lda (memmove__src),y
	sta (memmove__dst),y
	iny
	bne !-
	inc memmove__src+1
	inc memmove__dst+1
	dec memmove__size+1
	bne !-
	plp
	rts

#endif
