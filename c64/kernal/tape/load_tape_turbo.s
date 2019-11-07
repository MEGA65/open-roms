
//
// Tape (turbo) part of the LOAD routine
//

// Based on routine by enthusi/Onslaught, found here:
// - https://codebase64.pokefinder.org/doku.php?id=base:turbotape_loader_source


// XXX use calibration bits to improve reading


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

	// Read file header; structure described here:
	// - https://www.luigidifraia.com/c64/docs/tapeloaders.html#turbotape64
	//
	// 1 byte (skipped) - file type (0 = data, odd value = relocatable, even value = non-relocatable)
	// 2 bytes          - start address
	// 2 bytes          - end address + 1
	// 1 byte           - if $0B (tape timing) contained at the time of saving
	// 16 bytes         - filename, padded with 0x20

	jsr tape_turbo_sync_header
	ldy #$10

	// FALLTROUGH

load_tape_turbo_header_loop:           // this strange loop puts metadata after file name

	jsr tape_turbo_get_byte
	sta (TAPE1), y
	iny
	cpy #$15
	bne !+
	ldy #$00
!:
	cpy #$10
	bne load_tape_turbo_header_loop

	jsr tape_handle_header
	bcs load_tape_turbo_header         // if name does not match, look for other header

	// FALLTROUGH

load_tape_turbo_payload:

	// Initial checksum value

	lda #$00
	sta PRTY

	// Read file payload

	jsr tape_turbo_sync_payload

	// FALLTROUGH

load_tape_turbo_loop:

	jsr tape_turbo_get_byte
	sta (MEMUSS),y

	eor PRTY                           // handle checksum
	sta PRTY

	// Advance MEMUSS (see Mapping the C64, page 36)
	inc MEMUSS+0
	bne !+
	inc MEMUSS+1
!:
	lda MEMUSS+1
	cmp EAL+1
	bne load_tape_turbo_loop
	lda MEMUSS+0
	cmp EAL+0
	bne load_tape_turbo_loop

	// Get the checksum

	jsr tape_turbo_get_byte
	tax

	// Verify the checksum

	cpx PRTY
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
#if CONFIG_COLORS_BRAND && CONFIG_BRAND_ULTIMATE_64
	lda #$0B
#else
	lda #$06
#endif
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
