
//
// Variables used:
// - BLNSW (cursor blink switch)
// - BLNON (if cursor is visible)
// - BLNCT (cursor blink countdown)
//

cursor_show_if_enabled:
	lda BLNSW
	bne cursor_show_end
	lda BLNON
	bne cursor_show_end

	// FALLTROUGH

cursor_show:

	// Set cursor as though it had just finished the off phase,
	// so that the call to cursor_blink paints it
	lda #$00
	sta BLNCT
	sta BLNON
	jsr cursor_blink

	// Then set the timeout to 1 frame, so that the cursor
	// blinks under key repeat conditions, like on the original KERNAL
	lda #$01
	sta BLNCT

	// FALLTROUGH

cursor_show_end:
	rts
