#if ROM_LAYOUT_STD || (ROM_LAYOUT_M65 && SEGMENT_KERNAL_0)

//
// Keyboard part of the CHRIN routine
//


chrin_keyboard:

	// Save .X
	stx XSAV

	// Save .Y
	phy_trash_a

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

	// FALLTROUGH

empty_line:
	// For an empty line, just return the carriage return
	// (and do not forget to actually print the carriage return, so that
	// the cursor advances and screen scrolls as required)

	ply_trash_a
	ldx XSAV
	clc
	lda #$0d
	rts

not_end_of_input:
	// Advance index
	inc CRSW

	// Return next byte of waiting
	tay
chrin_keyboard_return_byte:
	lda (LXSP),y
	tax
	ply_trash_a
	txa
	ldx XSAV
	jsr screen_code_to_petscii
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
	// (Computes Mapping the 64, p96)

	// Set pointer to line of input
	lda PNT+0
	sta LXSP+0
	lda PNT+1
	sta LXSP+1

	// If the current line is a continuation of the previous one, decrease LXSP by 40
	ldy TBLX
	lda LDTBL, y
	bmi chrin_enter_calc_length        // branch if not continuation
	lda LXSP+0
	sec
	sbc #40
	sta LXSP+0
	bcs !+
	dec LXSP+1
!:
	ldy #80
	bne chrin_enter_loop               // branch always

chrin_enter_calc_length:

	// Calculate length
	jsr screen_get_logical_line_end_ptr
	iny
	
chrin_enter_loop:

	// Retrieve bytes
	dey
	bmi empty_line
	lda (LXSP),y
	cmp #$20
	beq chrin_enter_loop
	iny
	sty INDX
	lda #$01
	sta CRSW

	// Return first char of line
	ldy #$00
	beq chrin_keyboard_return_byte // branch always

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


#endif // ROM layout
