// #LAYOUT# M65 KERNAL_1 #TAKE
// #LAYOUT# *   *        #IGNORE

//
// Keyboard part of the CHRIN routine, version for MEGA65 native mode
//


m65_chrin_keyboard:       // XXX connnect this function to Kernal

	// Preserve .X, .Y and .Z register

	phx
	phy
	phz

	// FALLTROUGH

m65_chrin_keyboard_repeat:

	// Do we have a line of input we are currently returning?
	// If so, return the next byte, and clear the flag when we reach the end.

	lda CRSW
	beq m65_chrin_keyboard_read

	// We have input waiting at [M65__SCRINPUT]+CRSW
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

	lda #$0D

	// FALLTROUGH

m65_chrin_keyboard_end:

	plz
	ply
	plx
	clc
	rts

m65_chrin_keyboard_not_end_of_input:

	// Advance index, return the next byte
	
	inc CRSW
	tay

	// FALLTROUGH

m65_chrin_keyboard_return_byte:

	jsr m65_helper_scrlpnt_chrin

	tya
	taz
	lda_lp (M65_LPNT_SCR), z

	jsr screen_check_toggle_quote
	jsr screen_code_to_petscii

	jmp_8 m65_chrin_keyboard_end

m65_chrin_keyboard_read:

	jsr cursor_enable

	// Wait for a key
	lda NDX
	beq m65_chrin_keyboard_repeat
	lda KEYD
	cmp #$0D
	bne m65_chrin_keyboard_not_enter

	// FALLTROUGH

m65_chrin_keyboard_enter:

	// Disable cursor, retrieve code from keyboard buffer

	jsr m65_cursor_disable
	jsr pop_keyboard_buffer
	jsr m65_cursor_hide_if_visible

	// It was enter. Note that we have a line of input to return, and return the first byte
	// after computing and storing its length (Computes Mapping the 64, p96)

	// Set pointer to the input, start for the viewport offset + screen memory base
	clc
	lda M65_COLVIEW+0
	adc M65_SCRBASE+0
	sta M65__SCRINPUT+0
	lda M65_COLVIEW+1
	adc M65_SCRBASE+1
	sta M65__SCRINPUT+1
	// Add current row offset
	clc
	lda M65__SCRINPUT+0
	adc M65_TXTROW_OFF+0
	sta M65__SCRINPUT+0
	lda M65__SCRINPUT+1
	adc M65_TXTROW_OFF+1
	sta M65__SCRINPUT+1

	// Retrieve first byte which is not space

	jsr m65_helper_scrlpnt_chrin
	ldy INDX
	iny

	// FALLTROUGH

m65_chrin_enter_loop:

	// Skip spaces at the end of line
	dey
	bmi m65_chrin_keyboard_empty_line

	tya
	taz
	lda_lp (M65_LPNT_SCR), z
	cmp #$20
	beq m65_chrin_enter_loop
	iny
	sty INDX

	// XXX add windowed mode support here - correct INDX and M65__SCRINPUT

	// Set mark informing that we are returning a line
	ldy #$01
	sty CRSW

	// Clear quote mode mark
	dey
	sty QTSW

	// Return first char of line
	jmp_8 m65_chrin_keyboard_return_byte     // branch always


m65_chrin_keyboard_not_enter:

	lda KEYD

#if CONFIG_PROGRAMMABLE_KEYS

	jsr chrin_programmable_keys
	bcc m65_chrin_keyboard_enter

#endif // CONFIG_PROGRAMMABLE_KEYS

	// Print character, keep looking for input from keyboard until carriage return
	jsr CHROUT
	jsr pop_keyboard_buffer
	jmp m65_chrin_keyboard_repeat
