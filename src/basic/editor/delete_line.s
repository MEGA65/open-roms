// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE

//
// Delete the current BASIC line, which is assumed to have already been found with find_line.
// Consists of copying memory down and lline linkage update.
//

delete_line:

	// jsr printf
	// .text "DELETING LINE AT $"
	// .byte $f1,<OLDTXT,>OLDTXT
	// .byte $f0,<OLDTXT,>OLDTXT
	// .byte $0d,0

	// Get address of next line
	ldy #$00

#if CONFIG_MEMORY_MODEL_60K
	ldx #<OLDTXT
	jsr peek_under_roms
#elif CONFIG_MEMORY_MODEL_46K || CONFIG_MEMORY_MODEL_50K
	jsr peek_under_roms_via_OLDTXT
#else // CONFIG_MEMORY_MODEL_38K
	lda (OLDTXT),y
#endif

	sta __tokenise_work3
	iny

#if CONFIG_MEMORY_MODEL_60K	
	jsr peek_under_roms
#elif CONFIG_MEMORY_MODEL_46K || CONFIG_MEMORY_MODEL_50K
	jsr peek_under_roms_via_OLDTXT
#else // CONFIG_MEMORY_MODEL_38K
	lda (OLDTXT),y
#endif

	sta __tokenise_work4

	// Work out length of this line by looking at the pointer
	lda __tokenise_work3
	sec
	sbc OLDTXT+0
	sta __tokenise_work3
	lda __tokenise_work4
	sbc OLDTXT+1
	sta __tokenise_work4

	// jsr printf
	// .text "LINE LENGTH IS $"
	// .byte $f0,<__tokenise_work4,>__tokenise_work4
	// .byte $f0,<__tokenise_work3,>__tokenise_work3
	// .byte $0d,0
	
	lda __tokenise_work4
	sbc #0
	cmp #$00
	beq !+

	// Line length is <0 or >255 bytes.
	// Either way, things are bad, so abort.

	jmp do_MEMORY_CORRUPT_error
!:
	// Length can now be safely assumed to be in the low
	// byte only, i.e., stored in __tokenise_work3

	ldx __tokenise_work3

	// Shuffle everything down
	jsr shift_txt_down

	// Finish by fixing program linkage and calculating new 

	jmp update_LINKPRG_VARTAB_do_clr
