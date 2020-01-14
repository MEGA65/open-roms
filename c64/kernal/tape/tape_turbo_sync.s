#if ROM_LAYOUT_STD || (ROM_LAYOUT_M65 && SEGMENT_KERNAL_0)

//
// Tape (turbo) helper routine - synchronization handling
//

// Based on routine by enthusi/Onslaught, found here:
// - https://codebase64.pokefinder.org/doku.php?id=base:turbotape_loader_source


#if CONFIG_TAPE_TURBO


tape_turbo_sync_header:


#if CONFIG_TAPE_TURBO_AUTOCALIBRATE

	// Initial pulse threshold
	lda #$BF // auto-calibration under VICE often returns this value
	sta IRQTMP+0

	// Zero temporary stack area
	lda #$00
	ldy #$03
!:
	sta STACK, y
	dey
	bpl !-

#endif // CONFIG_TAPE_TURBO_AUTOCALIBRATE

	// Synchronize with start of sync sequence
	jsr tape_turbo_sync_first

	// Perform synchronization
	ldx #$C0
!:
	phx_trash_a
	ldy #$04
!:
	jsr tape_turbo_get_byte
	cmp #$02
	bne tape_turbo_sync_header         // branch if failure

	dey
	bne !-
	plx_trash_a
	dex
	bne !--

	// FALLTROUGH

#if CONFIG_TAPE_TURBO_AUTOCALIBRATE

tape_turbo_sync_calibrate:

	ldy #$80

	// FALLTROUGH

tape_turbo_sync_calibrate_loop:

	// Skip 5 bits
	phy_trash_a
	ldy #$04
!:
	jsr tape_turbo_get_bit
	bcs tape_turbo_sync_header
	dey
	bpl !-

	jsr tape_turbo_sync_measure_0
	jsr tape_turbo_sync_measure_1
	jsr tape_turbo_sync_measure_0

	ply_trash_a
	dey
	bne tape_turbo_sync_calibrate_loop

	// Calculate new pulse threshold as arithmetic mean
	// We accumulated 256 zeros and 128 ones, so calculating average value is easy

	lda STACK+0
	clc
	ror
	clc
	adc STACK+1
	sta IRQTMP+0

	// FALLTROUGH

#endif // CONFIG_TAPE_TURBO_AUTOCALIBRATE

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


#endif // ROM layout
