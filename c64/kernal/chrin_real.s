
//
// Official Kernal routine, described in:
//
// - [RG64] C64 Programmer's Reference Guide   - page 277/278
// - [CM64] Compute's Mapping the Commodore 64 - page 228
//
// CPU registers that has to be preserved (see [RG64]): .Y
//

// XXX keyboard part currently does not preserve register Y, to be fixed!
// XXX try to make chrin_real unnecessary (try to fit this into original location)

// Reads a byte of input, unless from keyboard.
// If from keyboard, then it gets a whole line of input, and returns the first char.
// Repeated calls after that read out the successive bytes of the line of input.

chrin_real:

	// Determine the device number
	lda DFLTN

	beq chrin_keyboard // #$00 - keyboard
	// XXX add screen support

#if CONFIG_IEC

	jsr iec_check_devnum_oc
	bcc chrin_iec
	jmp lvs_device_not_found_error // not a supported device

chrin_iec:

	jsr JACPTR
	bcs chrin_done_fail
	// FALLTROUGH

#endif // CONFIG_IEC

chrin_done:
	clc // indicate success
	rts

chrin_done_fail:
	sec // indicate failure
	rts

chrin_keyboard:

	// Save X
	phx_trash_a

chrin_repeat:

	// Do we have a line of input we are currently returning?
	// If so, return the next byte, and clear the flag when we reach the end.

	// Do we have a line of input waiting?
	lda CRSW
	beq read_from_keyboard

	// Yes, we have input waiting at (LXSP)+CRSW
	// When CRSW = INDX, then we return a carriage return
	// and clear the flag
	cmp INDX
	bne not_end_of_input

	// Return carriage return and clear pending input flag
	lda #$00
	sta CRSW
	plx_trash_a
	clc
	lda #$0d
	rts

not_end_of_input:
	// Return next byte of waiting input and advance index
	tay
	plx_trash_a
	lda (LXSP),y
	jsr screen_code_to_petscii
	inc CRSW
	clc
	rts

read_from_keyboard:

	jsr cursor_enable

	// Wait for a key
	lda NDX
	beq chrin_repeat

	lda KEYD
	cmp #$0D
	bne not_enter

chrin_enter:

	jsr cursor_disable
	jsr pop_keyboard_buffer
	jsr cursor_hide_if_visible

	// It was enter.
	// Note that we have a line of input to return, and return the first byte thereof
	// after computing and storing its length.
	// (Compute's Mapping the 64, p96)

	// Set pointer to line of input
	lda PNT+0
	sta LXSP+0
	lda PNT+1
	sta LXSP+1

	// Calculate length
	jsr screen_get_current_line_logical_length
	tay
	iny
!:	dey
	bmi empty_line
	lda (PNT),y
	cmp #$20
	beq !-
	iny
	sty INDX
	lda #$01
	sta CRSW
	// Return first char of line
	ldy #$00
	plx_trash_a
	lda (LXSP),y
	jsr screen_code_to_petscii
	clc
	rts

empty_line:
	// For an empty line, just return the carriage return
	// (and don't forget to actually print the carriage return, so that
	// the cursor advances and screen scrolls as required)
	plx_trash_a
	clc
	lda #$0d
	rts

not_enter:

	lda KEYD

#if CONFIG_PROGRAMMABLE_KEYS

	ldx #(__programmable_keys_codes_end - programmable_keys_codes - 1)

chrin_programmable_loop:

	cmp programmable_keys_codes, x
	beq chrin_programmable_key
	dex
	bpl chrin_programmable_loop

	// FALLTROUGH

#endif // CONFIG_PROGRAMMABLE_KEYS

chrin_print_character:

	jsr CHROUT
	jsr pop_keyboard_buffer

	// Keep looking for input from keyboard until carriage return
	jmp chrin_repeat

#if CONFIG_PROGRAMMABLE_KEYS

chrin_programmable_key:

	// .X contains index of the key code, we need offset to key string instead
	lda programmable_keys_offsets, x
	tax

	// Print all the characters assigned to key
!:
	lda programmable_keys_strings, x
	beq chrin_enter
	jsr CHROUT // our implementation preserves .X too
	inx
	bne !-     // jumps always

#endif // CONFIG_PROGRAMMABLE_KEYS
