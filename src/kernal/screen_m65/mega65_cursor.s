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

m65_cursor_hide_if_visible:

	lda BLNON
	beq m65_cursor_end

	// FALLTROUGH

m65_cursor_undraw:

	// XXX provide implementation

	rts


m65_cursor_show_if_enabled:

	// XXX provide implementation

	nop

	// FALLTROUGH

m65_cursor_end:

	rts
