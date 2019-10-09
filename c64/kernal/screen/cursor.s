
//
// Variables used:
// - BLNSW (cursor blink switch)
// - BLNCT (cursor blink countdown)
// - GDBLN (cursor saved character)
// - BLNON (if cursor is visible)
// - GDCOL (colour under cursor)
// - USER  (current screen line colour pointer)
// - PNT   (current screen line pointer)
// - PNTR  (current screen x position)
//


cursor_blink:
	// Is the cursor enabled?
	lda BLNSW
	bne cursor_blink_end

	// Do we need to redraw things?
	dec BLNCT
	bpl cursor_blink_end

	// Check if cursor was visible or not, and toggle
	lda BLNON
	bne cursor_undraw

	// FALLTROUGH

cursor_draw:
	jsr screen_calculate_line_pointer // XXX make sure this is not needed and remove the call

	ldy PNTR
	lda (PNT),y
	sta GDBLN
	eor #$80
	sta (PNT),y
	// Also set cursor colour
	lda (USER),y
	sta GDCOL
	lda COLOR
	sta (USER),y

	lda #1
	sta BLNON

	bne cursor_blink_timer_reset // branches always

cursor_disable:
	lda #$80
	sta BLNSW

	// FALLTHROUGH

cursor_hide_if_visible:
	lda BLNON
	beq cursor_blink_end

cursor_undraw:

	lda GDBLN
	ldy PNTR
	sta (PNT),y
	lda GDCOL
	sta (USER),y
	
	lda #0
	sta BLNON

	// FALLTROUGH

cursor_blink_timer_reset:

	// Rest blink counter (Mapping the 64, p39-40)
	lda #20
	sta BLNCT

	// FALLTROUGH

cursor_blink_end:
	rts
