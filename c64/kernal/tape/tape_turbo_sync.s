// #LAYOUT# STD *        #TAKE
// #LAYOUT# *   KERNAL_0 #TAKE
// #LAYOUT# *   *        #IGNORE

//
// Tape (turbo) helper routine - synchronization handling
//

// Based on routine by enthusi/Onslaught, found here:
// - https://codebase64.pokefinder.org/doku.php?id=base:turbotape_loader_source


#if CONFIG_TAPE_TURBO


tape_turbo_sync_header:

	// Initial pulse threshold
	lda #$BF                           // measured 128 bits '0' and 128 bits '1' under VICE, calculated average
	sta SYNO

	// Synchronize with start of sync sequence
	jsr tape_turbo_sync_first

	// Perform synchronization, double loop, total $C0 * $04 iterations
	ldx #$C0
!:
	ldy #$04
!:
	stx XSAV
	jsr tape_turbo_get_byte
	cmp #$02
	bne tape_turbo_sync_header         // branch if failure

	dey
	bne !-
	ldx XSAV
	dex
	bne !--

	// FALLTROUGH

tape_turbo_sync_payload:

	jsr tape_turbo_sync_first
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
