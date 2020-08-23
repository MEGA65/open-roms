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

	// Make sure IRQ won't interfere by increasing the counter      XXX reuse in legacy mode
	lda #$FF
	sta BLNCT

	// Disable cursor blinking
	lda #$80
	sta BLNSW

	// FALLTHROUGH

m65_cursor_hide_if_visible:

	// Set countdown to high value, to prevent IRQ interference
	lda #$FF
	sta BLNCT

	// If cursor is not visible, nothing to do
	lda BLNON
	beq m65_cursor_blink_timer_reset

	// FALLTROUGH

m65_cursor_undraw:

	// XXX provide implementation


	// Mark cursor as not drawn
	lda #0
	sta BLNON

	rts

m65_cursor_show_if_enabled:

	// XXX provide implementation

	lda #$00
	sta BLNSW

	// FALLTROUGH

m65_cursor_blink_timer_reset:    // XXX reuse code from main KERNAL

	// Rest blink counter (Mapping the 64, p39-40)
	lda #20
	sta BLNCT

	// FALLTROUGH

m65_cursor_blink_end:

	rts