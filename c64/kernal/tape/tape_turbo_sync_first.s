// #LAYOUT# STD *        #TAKE
// #LAYOUT# M65 KERNAL_1 #TAKE
// #LAYOUT# *   *        #IGNORE

//
// Tape (turbo) helper routine - syynchronize to first byte with value $02
//

#if CONFIG_TAPE_TURBO


tape_turbo_sync_first:

#if CONFIG_TAPE_AUTODETECT

	ldy #$00
!:
	jsr tape_turbo_get_bit 
	rol INBIT
	lda INBIT

	cmp #$FF
	bne !+
	iny
	bpl !-
	bmi tape_turbo_sync_first_fail     // suspiciously many $FF bytes, probably not a turbo tape
!:
	cmp #$02
	bne tape_turbo_sync_first

	clc
	rts

tape_turbo_sync_first_fail:

	sec
	rts

#else // no CONFIG_TAPE_AUTODETECT

	jsr tape_turbo_get_bit 
	rol INBIT
	lda INBIT

	cmp #$02
	bne tape_turbo_sync_first

	rts

#endif


#endif
