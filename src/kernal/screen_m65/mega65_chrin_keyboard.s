// #LAYOUT# M65 KERNAL_1 #TAKE
// #LAYOUT# *   *        #IGNORE

//
// Keyboard part of the CHRIN routine, version for MEGA65 native mode
//


m65_chrin_keyboard:       // XXX connnect this function to Kernal

	// Preserve .X and .Y registers

	phx
	phy

	// FALLTROUGH

m65_chrin_keyboard_repeat:

	// Do we have a line of input we are currently returning?
	// If so, return the next byte, and clear the flag when we reach the end.

	lda CRSW
	beq m65_chrin_keyboard_read

	// XXX implement

	// We have input waiting at (XXX)+CRSW
	// When CRSW = INDX, then we return a carriage return and clear the flag
	
	cmp INDX
	bne m65_chrin_keyboard_not_end_of_input

	// Clear pending input and quote flags

	lda #$00
	sta CRSW
	sta QTSW

	// FALLTROUGH

m65_chrin_keyboard_empty_line:

	// For an empty line, just return the carriage return

	ply
	plx
	clc
	lda #$0D
	rts

m65_chrin_keyboard_not_end_of_input:

	// Advance index, return the next byte
	
	inc CRSW
	tay

	// FALLTROUGH

m65_chrin_keyboard_return_byte:

	// XXX implement

	rts

m65_chrin_keyboard_read:

	jsr cursor_enable

	// Wait for a key
	lda NDX
	beq m65_chrin_keyboard_repeat

	lda KEYD
	cmp #$0D
	bne m65_chrkin_keyboard_not_enter

	// FALLTROUGH

m65_chrin_keyboard_enter:

	jsr m65_cursor_disable
	jsr pop_keyboard_buffer
	jsr m65_cursor_hide_if_visible

	// It was enter. Note that we have a line of input to return, and return the first byte
	// after computing and storing its length (Computes Mapping the 64, p96)

	// XXX implement

	rts





m65_chrkin_keyboard_not_enter:

	lda KEYD

#if CONFIG_PROGRAMMABLE_KEYS

	jsr chrin_programmable_keys
	bcc m65_chrin_keyboard_enter

#endif // CONFIG_PROGRAMMABLE_KEYS

	// Print character, keep looking for input from keyboard until carriage return
	jsr CHROUT
	jsr pop_keyboard_buffer
	jmp m65_chrin_keyboard_repeat
