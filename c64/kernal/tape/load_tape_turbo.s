
//
// Tape (turbo) part of the LOAD routine
//

// Based on routine by enthusi/Onslaught, found here:
// - https://codebase64.pokefinder.org/doku.php?id=base:turbotape_loader_source


// XXX use calibration bits to improve reading
// XXX find out how to use B0 tape timing
// XXX put header type into (TAPE1)


#if CONFIG_TAPE_TURBO


load_tape_turbo:

	jsr tape_ditch_verify              // only LOAD is supported, no VERIFY

	lda #$00
	sta CIA2_TIMAHI // $DD05
	lda #$FE                           // timer threshold for TurboTape
	sta CIA2_TIMALO // $DD04

	// Prepare for sound effects
	jsr tape_clean_sid

	// Start playing
	jsr tape_ask_play

	// FALLTROUGH

load_tape_turbo_header:

	// Read file header; structure described here:
	// - https://www.luigidifraia.com/c64/docs/tapeloaders.html#turbotape64
	//
	// 1 byte (skipped) - file type (0 = data, odd value = relocatable, even value = non-relocatable)
	// 2 bytes          - start address
	// 2 bytes          - end address + 1
	// 1 byte           - if $B0 (tape timing) contained at the time of saving
	//                    (we skip this one to match normal system header)
	// 16 bytes         - filename, padded with 0x20

	jsr tape_turbo_sync_header
	ldy #$01                           // to match original ROM header layout

	// FALLTROUGH

load_tape_turbo_header_loop:

	jsr tape_turbo_get_byte
	sta (TAPE1), y
	iny
	cpy #$05
	bne !+
	jsr tape_turbo_get_byte            // tape timing - skip this XXX how to use it?
!:
	cpy #$15
	bne load_tape_turbo_header_loop

	// Handle the header

	jsr tape_clean_sid
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
	jsr lvs_advance_MEMUSS_check_EAL
	bne load_tape_turbo_loop

	// Get the checksum
	jsr tape_turbo_get_byte
	tax

	// Silence audio
	jsr tape_clean_sid

	// Verify the checksum
	cpx PRTY
	beq_far tape_load_success
	jmp tape_load_error


#endif // CONFIG_TAPE_TURBO
