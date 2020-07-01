// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE

//
// Insert the tokenised line stored at $0200.
//
// First work out where in the list to put it (find_line with the line number can be used to work
// out the insertion point, as it should abort once it finds a line number too high).
// Then all we have to do is push the rest of the BASIC text up,
// and update the pointers in all following basic lines.
//

insert_line:

	// ASSUMES find_line has been called to set the insert point.

	// jsr printf
	// .text "INSERTING LINE AT $"
	// .byte $f1,<OLDTXT,>OLDTXT
	// .byte $f0,<OLDTXT,>OLDTXT
	// .byte $0d,0
	
	// Get number of bytes in tokenised line after line number
	lda __tokenise_work2
	sec
	sbc __tokenise_work1

	// Add on the five bytes space we need (2 bytes for linkage, 2 bytes for line number, 1 byte for terminator)
	clc
	adc #$05
	tax

	// Make the space
	jsr shift_txt_up

	// Put dummy linkage, we will correct it later
	ldy #$01
	tya

#if CONFIG_MEMORY_MODEL_60K
	ldx #<OLDTXT+0
	jsr poke_under_roms
#else // CONFIG_MEMORY_MODEL_38K || CONFIG_MEMORY_MODEL_46K || CONFIG_MEMORY_MODEL_50K
	sta (OLDTXT),y
#endif

	// Put the line number
	iny
	lda LINNUM+0

#if CONFIG_MEMORY_MODEL_60K
	jsr poke_under_roms
#else // CONFIG_MEMORY_MODEL_38K || CONFIG_MEMORY_MODEL_46K || CONFIG_MEMORY_MODEL_50K
	sta (OLDTXT),y
#endif

	iny
	lda LINNUM+1

#if CONFIG_MEMORY_MODEL_60K
	jsr poke_under_roms
#else // CONFIG_MEMORY_MODEL_38K || CONFIG_MEMORY_MODEL_46K || CONFIG_MEMORY_MODEL_50K
	sta (OLDTXT),y
#endif

	// Now store the line body itself
	inc __tokenise_work2
!:
	ldx __tokenise_work1
	lda $0200,x
	inc __tokenise_work1
	iny

#if CONFIG_MEMORY_MODEL_60K
	ldx #<OLDTXT+0
	jsr poke_under_roms
#else // CONFIG_MEMORY_MODEL_38K || CONFIG_MEMORY_MODEL_46K || CONFIG_MEMORY_MODEL_50K
	sta (OLDTXT),y
#endif

	lda __tokenise_work1
	cmp __tokenise_work2
	bne !-

	// FALLTROUGH

update_LINKPRG_VARTAB_do_clr:

	// Finish by fixing program linkage and calculating new VARTAB

	jsr LINKPRG
	jmp update_VARTAB_do_clr
