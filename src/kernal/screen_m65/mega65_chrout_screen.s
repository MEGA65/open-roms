// #LAYOUT# M65 KERNAL_1 #TAKE
// #LAYOUT# *   *        #IGNORE

//
// CHROUT routine - screen support (character output), MEGA65 native mode version
//


m65_chrout_screen:

	jsr m65_cursor_hide_if_visible

	// Retrieve the character to output

	lda SCHAR
	tax

	// All the PETSCII control codes are within $0x, $1x, $8x, $9x, remaining
	// ones are always printable characters; separate away control codes

	and #$60
	beq_16 m65_chrout_screen_control
	txa

	// Literals - first convert PETSCII to screen code

	jsr chrout_to_screen_code

	// FALLTROUGH

m65_chrout_screen_literal: // entry point for m65_chrout_screen_quote

	// Write normal character on the screen

	tax                                // store screen code, we need .A for calculations

	// Preserve .Z on stack

	phz

	// Prepare .Z and M65_LPNT_SCR for colour memory manipulation

	jsr m65_helper_scrlpnt_color

	// Store the new color in screen memory

	lda COLOR
	sta_lp (M65_LPNT_SCR),z

	// Now change M65_LPNT_SCR to point to screen memory

	jsr m65_helper_scrlpnt_to_screen

	// Store the new character in screen memory, restore .Z

	txa

	bit RVS
	bpl !+
	ora #$80                           // reverse the character  XXX consider doing this within chrout_to_screen_code
!:
	sta_lp (M65_LPNT_SCR),z
	
	// Restore .Z

	plz

	// Increment screen column by 1

	inc M65__TXTCOL

	// FALLTROUGH

m65_chrout_fix_column_row:

	ldy M65_SCRMODE

	bit M64_SCRWINMODE
	bmi m65_chrout_fix_column_row_win

	// Non-windowed mode

	// XXX
	// XXX provide implementation
	// XXX

	jmp_8 m65_chrout_fix_txtrow_off

m65_chrout_fix_column_row_win:

	// Windowed mode

	// XXX
	// XXX provide implementation
	// XXX

	nop

	// FALLTROUGH

m65_chrout_fix_txtrow_off:

	jsr m65_screen_upd_txtrow_off

	// FALLTROUGH

m65_chrout_screen_done:

	jsr cursor_show_if_enabled

	// XXX make sure it return success
	rts
