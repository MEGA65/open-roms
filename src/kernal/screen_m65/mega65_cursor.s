// #LAYOUT# M65 KERNAL_1 #TAKE
// #LAYOUT# *   *        #IGNORE

//
// Variables used:
// - BLNSW (cursor blink switch)
// - BLNCT (cursor blink countdown)
// - GDBLN (cursor saved character)
// - BLNON (if cursor is visible)
// - GDCOL (colour under cursor)
//


m65_cursor_disable:       // XXX utilize this!

	// Disable cursor blinking
	lda #$80
	sta BLNSW

	// FALLTHROUGH

m65_cursor_hide_if_visible:

	// Set countdown to high value, to prevent IRQ interference
	lda #$FF
	sta BLNCT

	// If cursor is not visible, not much to do
	lda BLNON
	beq_16 cursor_timer_reset

	// FALLTROUGH

m65_cursor_undraw:

	// Preserve .Z
	phz

	// Cursor undraw - color

	jsr m65_helper_scrlpnt_color
	ldz M65__TXTCOL
	lda GDCOL
	sta_lp (M65_LPNT_SCR),z

	// Cursor undraw - character

	jsr m65_helper_scrlpnt_to_screen
	lda GDBLN
	sta_lp (M65_LPNT_SCR),z

	// Restore .Z and continue as with normal editor
	plz
	jmp cursor_undraw_cont
