// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE


//
// Shift the BASIC program down to cover the area of removed line
//


shift_txt_down:

	// First byte of destination is OLDTXT

	lda OLDTXT+0
	sta memmove__dst+0
	lda OLDTXT+1
	sta memmove__dst+1	

	// First byte of source is memmove__dst + .X

	clc
	txa

	adc memmove__dst+0
	sta memmove__src+0
	lda memmove__dst+1
	adc #$00
	sta memmove__src+1

	// Size is distance from source to the end of BASIC text (VARTAB)

	lda VARTAB+0
	sec
	sbc memmove__src+0
	sta memmove__size+0
	lda VARTAB+1
	sbc memmove__src+1
	sta memmove__size+1

	// Perform the copy

	jmp shift_mem_down
