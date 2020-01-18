// #LAYOUT# STD *        #TAKE
// #LAYOUT# *   KERNAL_0 #TAKE
// #LAYOUT# *   *        #IGNORE

//
// Tape (turbo) helper routine - synchronization handling
//
// .Y should contain start value (either $89 or $09)
// Carry set = failed


#if CONFIG_TAPE_NORMAL


tape_normal_sync:

	lda #$06
	sta VIC_EXTCOL

	// Injest bytes of decreasing values

	jsr tape_normal_get_marker
	bcs tape_normal_sync_fail          // branch if end of data marker
	
	jsr tape_normal_get_byte
	bcs tape_normal_sync_fail

	cpy INBIT                          // INBIT contains same value as .A
	bne tape_normal_sync_fail

	dey
	and #%01111110
	bne tape_normal_sync               // branch if not $80 and not $00

	clc
	rts


tape_normal_sync_fail:

	sec
	rts


#endif
