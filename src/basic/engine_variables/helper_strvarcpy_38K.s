// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE

//
// Helper routine to copy string descriptor
//


#if CONFIG_MEMORY_MODEL_38K

helper_strvarcpy:

	// Retrieve pointer to destination

	ldy #$02
	lda (VARPNT), y
	sta DSCPNT+2
	dey
	lda (VARPNT), y
	sta DSCPNT+1
	dey

	// .Y is now 0 - copy the content
!:
	lda (__FAC1+1),y
	sta (DSCPNT+1),y
	iny
	cpy __FAC1+0
	bne !-

	rts

#endif
