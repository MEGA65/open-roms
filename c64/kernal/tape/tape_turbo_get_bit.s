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

#if CONFIG_TAPE_NORMAL
	
	jsr tape_normal_get_pulse          // reuse routine from NORMAL system

#else

	lda #$10
!:
	bit CIA1_ICR    // $DC0D
	beq !-                             // busy loop to detect signal, restart timer afterwards
	lda CIA2_TIMBLO // $DD06
	ldx #%01010001                     // start timer, force latch reload, count timer A underflows
	stx CIA2_CRB    // $DD0F

#endif

	cmp SYNO                           // threshold
	bcs !+

	clc
	ror
	sta IRQTMP+0                       // store half of the last measurement result for short pulse

	lda #$01
	sta SID_SIGVOL
	lda #$06
	sta VIC_EXTCOL
	sec
	rts
!:
	clc
	ror
	sta IRQTMP+1                       // store half of the last measurement result for long pulse

	lda #$00
	sta SID_SIGVOL
	sta VIC_EXTCOL
	clc
	rts


#endif // CONFIG_TAPE_TURBO
