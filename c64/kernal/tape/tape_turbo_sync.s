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


#if !CONFIG_TAPE_TURBO_AUTOCALIBRATE

	// Synchronize with start of sync sequence
	jsr tape_turbo_sync_first

	// Perform synchronization, double loop, total $C0 * $04 iterations
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

#else // CONFIG_TAPE_TURBO_AUTOCALIBRATE

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

	// Synchronize with start of sync sequence
	jsr tape_turbo_sync_first

	// Perform synchronization, get measurements from 128 bytes
	ldx #$10

	// FALLTROUGH

tape_turbo_sync_outer_loop:

    // Set .Y (inner loop counter) to $28-$38, average $30; $10 * $30 equals $C0 * $04
	// We want a bit of irregularity with byte selection for calibration
	txa
	pha                                          // store .X
	clc
	adc #$27
	tay
	
	// FALLTROUGH

tape_turbo_sync_inner_loop:

	cpy #$09
	bcc !+                                       // if inner couter is 8 or lower, get this byte for measurement

	// Get byte without measurements
	jsr tape_turbo_get_byte
	cmp #$02
	bne tape_turbo_sync_header                   // branch if failure
	beq tape_turbo_sync_header_next_iter         // branch always
	
!:
	// Get byte and take measurements

	phy_trash_a

	// Skip 5 bits, they should be all 0
	ldy #$04
!:
	jsr tape_turbo_get_bit
	bcs tape_turbo_sync_header
	dey
	bpl !-

	// Get measurements from 3 bits
	jsr tape_turbo_sync_measure_0
	jsr tape_turbo_sync_measure_1
	jsr tape_turbo_sync_measure_0

	ply_trash_a

	// FALLTROUGH

tape_turbo_sync_header_next_iter:

	dey
	bne tape_turbo_sync_inner_loop
	plx_trash_a
	dex
	bne tape_turbo_sync_outer_loop

	// Calculate new pulse threshold as arithmetic mean
	// We accumulated 256 zeros and 128 ones, so calculating average value is easy

	lda STACK+0
	clc
	ror
	clc
	adc STACK+1
	sta IRQTMP+0

#endif // CONFIG_TAPE_TURBO_AUTOCALIBRATE

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
