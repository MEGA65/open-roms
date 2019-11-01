
//
// Tape (turbo) part of the LOAD routine
//

// Based on routine by enthusi/Onslaught, found here:
// - https://codebase64.pokefinder.org/doku.php?id=base:turbotape_loader_source


// XXX use calibration bits to improve reading
// XXX handle load address from Kernal API
// XXX finish pattern matching


#if CONFIG_TAPE_TURBO


load_tape_turbo:

	jsr tape_ditch_verify              // only LOAD is supported, no VERIFY

	lda #$00
	sta CIA2_TIMAHI
	lda #$FE                           // timer threshold for TurboTape
	sta CIA2_TIMALO

	jsr tape_ask_play

	// FALLTROUGH

load_tape_turbo_header:

	// Read file header

	jsr tape_turbo_sync_header

	ldy #$00
!:
	jsr tape_turbo_get_byte
	sta (TAPE1), y
	iny
	cpy #$15
	bne !-

	jsr tape_handle_header
	bcs load_tape_turbo_header         // if name does not match, look for other header

	// FALLTROUGH

load_tape_turbo_payload:

	// Read file payload

	jsr tape_turbo_sync_payload

	ldy #$00
	sty PRTY                           // initial checksum value

	// FALLTROUGH

load_tape_turbo_loop:

	jsr tape_turbo_get_byte

	dec CPU_R6510                      // to load below I/O area
	sta (STAL),y
	inc CPU_R6510

	eor PRTY                           // handle checksum
	sta PRTY

	jsr lvs_advance_pointer

	lda STAL+1
	cmp EAL+1
	bne load_tape_turbo_loop
	lda STAL+0
	cmp EAL+0
	bne load_tape_turbo_loop

	// Verify the checksum

	jsr tape_turbo_get_byte
	cmp PRTY
	beq_far tape_load_success
	jmp tape_load_error

tape_turbo_get_byte:

	lda #$01	
	sta ROPRTY                         // init the to-be-read byte with 1
!:
	jsr tape_turbo_get_bit	
	rol ROPRTY
	bcc !-	                           // is the initial 1 shifted into carry already?
	lda ROPRTY                         // much nicer than ldx #8: dex: loop
	
	rts	


tape_turbo_get_bit:

	lda #$10	
!:
	bit CIA1_ICR	
	beq !-                             // busy loop to detect signal
	lda CIA2_ICR
	pha	
	lda #$19	
	sta CIA2_CRA	
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

tape_turbo_sync_common:

	jsr tape_turbo_get_bit 
	rol ROPRTY
	lda ROPRTY
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
	ldx #$09                           // 9,8,... is real turboTape
!:                                     // I sometimes used 8,7,6... to avoid it being listed in vice :)
 	jsr tape_turbo_get_byte
 	cmp #$02
 	beq !-
 	ldy #$00
!: 
	cpx ROPRTY
	bne tape_turbo_sync_payload
	jsr tape_turbo_get_byte
	dex
	bne !-

	rts 


#endif // CONFIG_TAPE_TURBO
