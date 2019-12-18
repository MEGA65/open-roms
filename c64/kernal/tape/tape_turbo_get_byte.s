
//
// Tape (turbo) helper routine - byte reading
//
// Returns byte in .A
//

// Based on routine by enthusi/Onslaught, found here:
// - https://codebase64.pokefinder.org/doku.php?id=base:turbotape_loader_source


#if CONFIG_TAPE_TURBO


tape_turbo_get_byte:

	lda #$01
	sta ROPRTY                         // init the to-be-read byte with 1 (canary bit to mark loop end)
!:
	jsr tape_turbo_get_bit	
	rol ROPRTY
	bcc !-	                           // is the initial 1 shifted into carry already?
	lda ROPRTY                         // much nicer than ldx #8: dex: loop
	
	rts


#endif // CONFIG_TAPE_TURBO
