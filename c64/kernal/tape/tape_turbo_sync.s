
//
// Tape (turbo) helper routine - synchronization handling
//

// Based on routine by enthusi/Onslaught, found here:
// - https://codebase64.pokefinder.org/doku.php?id=base:turbotape_loader_source


#if CONFIG_TAPE_TURBO


tape_turbo_sync_common:

	jsr tape_turbo_get_bit 
	rol INBIT
	lda INBIT
	cmp #$02
	bne tape_turbo_sync_common
	rts

tape_turbo_sync_header:

	ldx #$FF
!:
	ldy #$03
!:
	jsr tape_turbo_sync_common
	dey
	bne !-
	dex
	bne !--

	// FALLTROUGH

tape_turbo_sync_payload:

	jsr tape_turbo_sync_common
!:
	ldx #$09                           // 9, 8, ...
!:
 	jsr tape_turbo_get_byte
 	cmp #$02
 	beq !-
 	ldy #$00
!: 
	cpx INBIT
	bne tape_turbo_sync_payload
	jsr tape_turbo_get_byte
	dex
	bne !-

	rts 


#endif // CONFIG_TAPE_TURBO
