// We have the following variables:
// cursor_blink_disable
// cursor_blink_countdown
// cursor_saved_character
// cursor_is_visible
// colour_under_cursor

show_cursor_if_enabled:
	lda cursor_blink_disable
	beq !+
	rts
!:	lda cursor_is_visible
	beq show_cursor
	rts
	
show_cursor:
	// Set cursor as though it had just finished the off phase,
	// so that the call to blink_cursor paints it
	lda #$00
	sta cursor_blink_countdown
	sta cursor_is_visible
	jsr blink_cursor
	// Then set the timeout to 1 frame, so that the cursor
	// blinks under key repeat conditions, like on the original KERNAL
	lda #$01
	sta cursor_blink_countdown
	rts
	
blink_cursor:
	// Is the cursor enabled?
	lda cursor_blink_disable
	bne no_blink_cursor

	// Do we need to redraw things?
	dec cursor_blink_countdown
	bpl no_blink_cursor

	// Check if cursor was visible or not, and toggle
	lda cursor_is_visible
	bne undraw_cursor
draw_cursor:
	jsr calculate_screen_line_pointer

	ldy current_screen_x
	lda (current_screen_line_ptr),y
	sta cursor_saved_character	
	eor #$80
	sta (current_screen_line_ptr),y
	// Also set cursor colour
	lda (current_screen_line_colour_ptr),y
	sta colour_under_cursor
	lda text_colour
	sta (current_screen_line_colour_ptr),y
	
	lda #1
	sta cursor_is_visible
	
	jmp reset_blink_timer

undraw_cursor:
	jsr calculate_screen_line_pointer

	lda cursor_saved_character
	ldy current_screen_x
	sta (current_screen_line_ptr),y
	lda colour_under_cursor
	sta (current_screen_line_colour_ptr),y
	
	lda #0
	sta cursor_is_visible
	// Fall through
reset_blink_timer:	
	// Rest blink counter
	// (Compute's Mapping the 64, p39-40)
	lda #20
	sta cursor_blink_countdown
no_blink_cursor:
	rts

disable_cursor:
	lda #$80
	sta cursor_blink_disable
	// FALL THROUGH
hide_cursor_if_visible:
	lda cursor_is_visible
	bne undraw_cursor
	rts

enable_cursor:
	lda #$00
	sta cursor_blink_disable
	rts

