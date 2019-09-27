// We have the following variables:
// BLNSW (cursor blink switch)
// BLNCT (cursor blink countdown)
// GDBLN (cursor saved character)
// BLNON (if cursor is visible)
// GDCOL (colour under cursor)
// USER  (current screen line colour pointer)
// PNT   (current screen line pointer)
// PNTR  (current screen x position)

show_cursor_if_enabled:
	lda BLNSW
	beq !+
	rts
!:	lda BLNON
	beq show_cursor
	rts

show_cursor:
	// Set cursor as though it had just finished the off phase,
	// so that the call to blink_cursor paints it
	lda #$00
	sta BLNCT
	sta BLNON
	jsr blink_cursor
	// Then set the timeout to 1 frame, so that the cursor
	// blinks under key repeat conditions, like on the original KERNAL
	lda #$01
	sta BLNCT
	rts

blink_cursor:
	// Is the cursor enabled?
	lda BLNSW
	bne no_blink_cursor

	// Do we need to redraw things?
	dec BLNCT
	bpl no_blink_cursor

	// Check if cursor was visible or not, and toggle
	lda BLNON
	bne undraw_cursor
draw_cursor:
	jsr calculate_screen_line_pointer

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

	jmp reset_blink_timer

undraw_cursor:
	jsr calculate_screen_line_pointer

	lda GDBLN
	ldy PNTR
	sta (PNT),y
	lda GDCOL
	sta (USER),y
	
	lda #0
	sta BLNON
	// Fall through
reset_blink_timer:	
	// Rest blink counter
	// (Compute's Mapping the 64, p39-40)
	lda #20
	sta BLNCT
no_blink_cursor:
	rts

disable_cursor:
	lda #$80
	sta BLNSW
	// FALL THROUGH
hide_cursor_if_visible:
	lda BLNON
	bne undraw_cursor
	rts

enable_cursor:
	lda #$00
	sta BLNSW
	rts

