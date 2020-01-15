// #LAYOUT# STD *        #TAKE
// #LAYOUT# *   KERNAL_0 #TAKE
// #LAYOUT# *   *        #IGNORE

//
// Tape (turbo) helper routine - syynchronize to first byte with value $02
//

#if CONFIG_TAPE_TURBO


tape_turbo_sync_first:

	jsr tape_turbo_get_bit 
	rol INBIT
	lda INBIT
	cmp #$02
	bne tape_turbo_sync_first

	rts


#endif
