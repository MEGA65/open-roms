// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE

//
// Calculate the VARTAB value - to mark the end of BASIC program code. Also clears all variables.
//

calculate_VARTAB:

	lda TXTTAB+0
	sta OLDTXT+0
	lda TXTTAB+1
	sta OLDTXT+1
!:
	lda OLDTXT+0
	sta VARTAB+0
	lda OLDTXT+1
	sta VARTAB+1

	jsr basic_follow_link_to_next_line

	lda OLDTXT+0
	ora OLDTXT+1
	bne !-                                       // branch if pointer not NULL

	// Correct VARTAB by 2 bytes NULL pointer

#if HAS_OPCODES_65CE02

	inw VARTAB
	inw VARTAB

#else

	clc
	lda VARTAB+0
	adc #$02
	sta VARTAB+0
	bcc !+
	inc VARTAB+1
!:
#endif

	// Call CLR to set-up remaining variables

	jmp do_clr
