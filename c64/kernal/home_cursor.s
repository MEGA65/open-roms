	;; Home the cursor
	;; (Compute's Mapping the 64 p216)

home_cursor:

	lda #$00
	sta current_screen_x
	sta current_screen_y

	jmp set_pointer_to_current_screen_line
