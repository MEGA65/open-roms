#if ROM_LAYOUT_STD || (ROM_LAYOUT_M65 && SEGMENT_KERNAL_0)

//
// Tape (turbo) helper routine - bit reading
//

// Based on routine by enthusi/Onslaught, found here:
// - https://codebase64.pokefinder.org/doku.php?id=base:turbotape_loader_source


#if CONFIG_TAPE_TURBO


tape_turbo_get_bit:

	lda #$10
!:
	bit CIA1_ICR    // $DC0D
	beq !-                             // busy loop to detect signal, restart timer afterwards
	lda CIA2_TIMBLO // $DD06
	ldx #%01010001                     // start timer, force latch reload, count timer A underflows
	stx CIA2_CRB    // $DD0F

#if CONFIG_TAPE_TURBO_AUTOCALIBRATE
	tax
	cmp IRQTMP+0
#else
	cmp #$BF                           // threshold calculated by autocalibration routines under VICE
#endif

	bcs !+

	lda #$01
	sta SID_SIGVOL
	lda #$06
	sta VIC_EXTCOL
	sec
	rts
!:
	lda #$00
	sta SID_SIGVOL
	sta VIC_EXTCOL
	clc
	rts


#endif // CONFIG_TAPE_TURBO


#endif // ROM layout
