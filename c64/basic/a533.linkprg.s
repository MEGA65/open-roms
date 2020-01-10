#if ROM_LAYOUT_STD || (ROM_LAYOUT_M65 && SEGMENT_BASIC_0)

//
// Well-known BASIC routine, described in:
//
// - [CM64] Computes Mapping the Commodore 64 - page 95
// - https://www.lemon64.com/forum/viewtopic.php?t=64721&sid=bc400a5a6d404f8f092e4d32a92f5de7
//

LINKPRG:

	// Start by getting pointer to the first line
	jsr init_oldtxt

linkprg_loop:
	// Is the pointer to the end of the program
	ldy #1

#if CONFIG_MEMORY_MODEL_60K
	ldx #<OLDTXT+0
	jsr peek_under_roms
	cmp #$00
#else // CONFIG_MEMORY_MODEL_38K
	lda (OLDTXT),y
#endif

	bne !+

	// End of program
	rts
!:
	// Now search forward to find the end of the line
	// Skip forward pointer and line number
	ldy #4

linkprg_end_of_line_search:

#if CONFIG_MEMORY_MODEL_60K
	ldx #<OLDTXT+0
	jsr peek_under_roms
#else // CONFIG_MEMORY_MODEL_38K
	lda (OLDTXT),y
#endif

	cmp #$00
	beq !+

	// Not yet end of line
	iny
	bne linkprg_end_of_line_search

	// line too long
	jmp do_STRING_TOO_LONG_error

!:
	// Found end of line, so update pointer

	// First, skip over the $00 char
	iny

	// Now overwrite the pointer (carefully)
	//
	tya
	clc
	adc OLDTXT+0
	pha
	php
	ldy #0

#if CONFIG_MEMORY_MODEL_60K
	ldx #<OLDTXT+0
	jsr poke_under_roms
#else // CONFIG_MEMORY_MODEL_38K
	sta (OLDTXT),y
#endif

	plp
	lda OLDTXT+1
	adc #0
	ldy #1

#if CONFIG_MEMORY_MODEL_60K
	jsr poke_under_roms
#else // CONFIG_MEMORY_MODEL_38K
	sta (OLDTXT),y
#endif

	sta OLDTXT+1
	pla
	sta OLDTXT+0

	jmp linkprg_loop


#endif // ROM layout
