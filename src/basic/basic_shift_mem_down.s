// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE


//
// Shift the BASIC program down to cover the area of removed line
//


basic_shift_mem_down_and_relink:

	// Destination is OLDTXT

	lda OLDTXT+0
	sta memmove__dst+0
	lda OLDTXT+1
	sta memmove__dst+1	

	// Source is OLDTXT + .X

	clc
	txa

	adc OLDTXT+0
	sta memmove__src+0
	lda OLDTXT+1
	adc #$00
	sta memmove__src+1

	// Size is distance from source (OLDTXT) to the end of BASIC text (VARTAB)

	lda VARTAB+0
	sec
	sbc memmove__src+0
	sta memmove__size+0
	lda VARTAB+1
	sbc memmove__src+1
	sta memmove__size+1

	// The copy routine is simplified, so that it is fast and (for memory model 60K)
	// can fit in a small RAM area - therefore it requires to pre-set .Y, so that
	// the copy ends when it reaches 0; so if copying one byte we want .Y = $FF

	sec
	lda #$00
	sbc memmove__size+0
	tay
	sty __tokenise_work3

	// Now we have to move down the memmove_src and memmove_dst pointers
	// to compensate for .Y not being 0

	sec
	lda memmove__src+0
	sbc __tokenise_work3
	sta memmove__src+0
	bcs !+
	dec memmove__src+1
!:
	sec
	lda memmove__dst+0
	sbc __tokenise_work3
	sta memmove__dst+0
	bcs !+
	dec memmove__dst+1
!:
	// Perform the copy    XXX add more documentation inside the copy routine!

	inc memmove__size+1
	jsr shift_mem_down

	// Now fix program linkage and calculate VARTAB

	jsr LINKPRG
	jmp calculate_VARTAB
