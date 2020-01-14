#if ROM_LAYOUT_STD || (ROM_LAYOUT_M65 && SEGMENT_KERNAL_0)

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
	lda INBIT

	rts


#endif // CONFIG_TAPE_TURBO


#endif // ROM layout
