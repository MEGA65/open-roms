// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE

//
// Helper routine for memory copy. Moves down the memmove_src and memmove_dst pointers to compensate for .Y not being 0
//


shift_mem_adapt_pointers:

	sty memmove__tmp

	// Adapt source pointer

	sec
	lda memmove__src+0
	sbc memmove__tmp
	sta memmove__src+0
	bcs !+
	dec memmove__src+1
!:
	// Adapt destination pointer

	sec
	lda memmove__dst+0
	sbc memmove__tmp
	sta memmove__dst+0
	bcs !+
	dec memmove__dst+1
!:
	// Adapt data size

	inc memmove__size+1

	rts
