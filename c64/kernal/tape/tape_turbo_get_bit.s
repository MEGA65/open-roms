
//
// Tape (turbo) helper routine - bit reading
//

// Based on routine by enthusi/Onslaught, found here:
// - https://codebase64.pokefinder.org/doku.php?id=base:turbotape_loader_source


#if CONFIG_TAPE_TURBO


tape_turbo_get_bit:

	lda #$10	
!:
	bit CIA1_ICR // $DC0D	
	beq !-                             // busy loop to detect signal
	lda CIA2_ICR // $DD0D
	pha
	lda #%00011001                     // start timer, one-shot, force latch reload
	sta CIA2_CRA // $DD0E	
	pla
	
	pha                                // audio/video effects
	asl
	sta SID_SIGVOL
	beq !+
	lda #$06
!:
	sta VIC_EXTCOL
	pla

	lsr
	rts


#endif // CONFIG_TAPE_TURBO
