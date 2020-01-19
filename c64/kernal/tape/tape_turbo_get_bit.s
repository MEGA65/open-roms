// #LAYOUT# STD *        #TAKE
// #LAYOUT# *   KERNAL_0 #TAKE
// #LAYOUT# *   *        #IGNORE

//
// Tape (turbo) helper routine - bit reading
//

// Based on routine by enthusi/Onslaught, found here:
// - https://codebase64.pokefinder.org/doku.php?id=base:turbotape_loader_source


#if CONFIG_TAPE_TURBO


tape_turbo_get_bit:
	
	jsr tape_common_get_pulse
	bcs !+

	clc
	ror
	sta __turbo_half_S                 // store half of the last measurement result for short pulse

	lda #$01
	sta SID_SIGVOL
	lda #$06
	sta VIC_EXTCOL
	sec
	rts
!:
	clc
	ror
	sta __turbo_half_L                 // store half of the last measurement result for long pulse

	lda #$00
	sta SID_SIGVOL
	sta VIC_EXTCOL
	clc
	rts


#endif // CONFIG_TAPE_TURBO
