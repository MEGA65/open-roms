// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE

//
// Helper routine to copy string descriptor, for LET command
//


#if CONFIG_MEMORY_MODEL_60K

helper_let_strdesccpy:

	ldx #<VARPNT

	ldy #$02
	jsr peek_under_roms
	sta DSCPNT+2
	dey
	jsr peek_under_roms
	sta DSCPNT+1
	dey

	// .Y is now 0 - copy the content
!:

	ldx #<__FAC1+1
	jsr peek_under_roms
	ldx #<DSCPNT+1
	jsr poke_under_roms
	iny
	cpy __FAC1+0
	bne !-

	rts

#endif
