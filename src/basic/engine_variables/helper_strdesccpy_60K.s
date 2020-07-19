// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE

//
// Helper routine to copy string descriptor
//


#if CONFIG_MEMORY_MODEL_60K

helper_strdesccpy:

	ldx #<VARPNT

	ldy #$00
	jsr peek_under_roms
	sta DSCPNT+0
	iny
	jsr peek_under_roms
	sta DSCPNT+1
	iny
	jsr peek_under_roms
	sta DSCPNT+2

	rts

#endif
