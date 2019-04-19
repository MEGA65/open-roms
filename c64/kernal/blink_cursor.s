	;; We have the following variables:
	;; cursor_blink_disable
	;; cursor_blink_countdown
	;; cursor_saved_character
	;; cursor_is_visible
	;; colour_under_cursor
	
blink_cursor:
	;; Is the cursor enabled?
	bit cursor_blink_disable
	bne no_blink_cursor

	;; Do we need to redraw things?
	dec cursor_blink_countdown
	bpl no_blink_cursor

	;; XXX - Save character colour also!
	
	;; Check if cursor was visible or not, and toggle
	lda cursor_is_visible
	bne undraw_cursor
draw_cursor:
	ldy current_screen_x
	lda (current_screen_line_ptr),y
	sta cursor_saved_character
	eor #$80
	sta (current_screen_line_ptr),y
	lda #1
	sta cursor_is_visible
	jmp reset_blink_timer

undraw_cursor:
	lda cursor_saved_character
	ldy current_screen_x
	sta (current_screen_line_ptr),y
	lda #0
	sta cursor_is_visible
	;; Fall through
reset_blink_timer:	
	;; Rest blink counter
	;; (Compute's Mapping the 64, p39-40)
	lda #20
	sta cursor_blink_countdown
no_blink_cursor:

	rts

hide_cursor_if_visible:
	bit cursor_is_visible
	bpl undraw_cursor
	rts
