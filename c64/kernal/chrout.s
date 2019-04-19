; Function defined on pp272-273 of C64 Programmers Reference Guide
chrout:
	;; Crude implementation of character output	

	;; Save X and Y values
	;; (Confirmed by writing a test program that X and Y
	;; don't get modified, in agreement with C64 PRG's
	;; description of CHROUT)
	sta last_printed_character_ascii
	txa
	pha
	tya
	pha
	lda last_printed_character_ascii
	
	;; Write character on the screen
	ldy current_screen_x

	;;  Convert PETSCII to screen code
	cmp #$40
	bcc chrout_l1
	cmp #$41+26
	bcs chrout_l1
	and #$1f

chrout_l1:	
	sta (current_screen_line_ptr),y

	;; Advance the column, and scroll screen down if we need
	;; to insert a 2nd line in this logical line.
	;; (eg Compute's Mapping the 64 p41)
	ldx current_screen_y
	iny
	sty current_screen_x
	cpy #40
	bne no_screen_advance_to_next_line
	jsr screen_grow_logical_line
	cpy #79
	bcc no_screen_advance_to_next_line
	jsr screen_advance_to_next_line
no_screen_advance_to_next_line:

	;; Restore X and Y
	pla
	tay
	pla
	tax
	
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
