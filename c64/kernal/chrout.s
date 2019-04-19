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
	tax
	

	;; Check for special characters

	;; Linefeed (simply ignored)
	;; Trivia: BASIC does CRLF with READY. prompt
	cmp #$0a
	bne not_0a
	jmp chrout_done
not_0a:
	
	;; Carriage return
	cmp #$0d		
	beq screen_advance_to_next_line

	;; Clear screen
	cmp #$93
	bne not_clearscreen
	jsr clear_screen
	jmp chrout_done
	
not_clearscreen:	
	
	;;  Convert PETSCII to screen code
	cmp #$40
	bcc chrout_l1
	cmp #$41+26
	bcs chrout_l1
	and #$1f

chrout_l1:	
	;; Write normal character on the screen
	ldy current_screen_x
	sta (current_screen_line_ptr),y

	;; XXX - Update colour RAM also

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
	jmp screen_advance_to_next_line
no_screen_advance_to_next_line:
chrout_done:	
	;; Restore X and Y, set carry to mark success on exit
	pla
	tay
	pla
	tax
	lda last_printed_character_ascii
	clc 			; indicate success
	rts

screen_grow_logical_line:
	;; XXX - Scroll screen down to make space

	rts
	
screen_advance_to_next_line:
	;;  Go to start of line
	lda #0
	sta current_screen_x
	;;  Advance line number
	ldy current_screen_y
	inc current_screen_y

	;; Advance screen pointer to next line
	lda screen_line_link_table,y
	bpl line_not_linked
	jsr advance_screen_pointer_40_bytes

line_not_linked:	
	jsr advance_screen_pointer_40_bytes
	
	;; Work out if we have gone off the bottom of the screen?

	;; XXX -- implement this check and scrolling of the screen
	;; and updating the screen line links.
	
	jmp chrout_done

advance_screen_pointer_40_bytes:
	lda current_screen_line_ptr+0
	clc
	adc #<40
	sta current_screen_line_ptr+0
	lda current_screen_line_ptr+1
	adc #>40
	sta current_screen_line_ptr+1
	rts
