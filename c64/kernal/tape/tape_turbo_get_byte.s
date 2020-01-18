// #LAYOUT# STD *        #TAKE
// #LAYOUT# *   KERNAL_0 #TAKE
// #LAYOUT# *   *        #IGNORE

//
// Tape (turbo) helper routine - byte reading
//
// Returns byte in .A
//

// Based on routine by enthusi/Onslaught, found here:
// - https://codebase64.pokefinder.org/doku.php?id=base:turbotape_loader_source


#if CONFIG_TAPE_TURBO


tape_turbo_get_byte:

	phx_trash_a
	lda #$01
	sta INBIT                          // init the to-be-read byte with 1 (canary bit to mark loop end)
!:
	jsr tape_turbo_get_bit	
	rol INBIT
	bcc !-	                           // is the initial 1 shifted into carry already?
	plx_trash_a

	// Compensate for tape speed variations

	lda IRQTMP+0                       // half of the last value for bit '0'
	clc
	adc IRQTMP+1                       // half of the last value for bit '1'
	
	sec
	sbc SYNO                           // now we have a diff between current threshold and calculated one
	beq tape_turbo_get_byte_done       // branch if threshold correction not needed

	bpl !+

	lda SYNO
	cmp #($BF - 10)
	beq tape_turbo_get_byte_done       // do not decrease threshold too far no matter what

	dec SYNO
	bne tape_turbo_get_byte_done       // branch always
!:
	lda SYNO
	cmp #($BF + 10)
	beq tape_turbo_get_byte_done       // do not increase threshold too far no matter what

	inc SYNO

tape_turbo_get_byte_done:

	lda INBIT
	rts


#endif // CONFIG_TAPE_TURBO
