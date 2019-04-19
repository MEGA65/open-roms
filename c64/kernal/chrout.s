; Function defined on pp272-273 of C64 Programmers Reference Guide
chrout:
	;; Crude implementation of character output	
	
	;; Write character on the screen
	ldy current_screen_x
	sta (current_screen_line_ptr),y

	;; Advance the column, and scroll screen down if we need
	;; to insert a 2nd line in this logical line.
	;; (eg Compute's Mapping the 64 p41)
	ldx current_screen_y
	iny
	sty current_screen_x
	cpy #40
	beq screen_grow_logical_line
	cpy #79
	bcs screen_advance_to_next_line
	rts

screen_grow_logical_line:
	;; XXX - Scroll screen down to make space

	rts
	
screen_advance_to_next_line:
	;;  Go to start of line
	lda #0
	sta current_screen_x
	;;  Advance line number
	inc current_screen_y
	;; Work out if we have gone off the bottom of the screen?

	;; XXX -- implement this check and scrolling of the screen
	;; and updating the screen line links.
	
	rts
