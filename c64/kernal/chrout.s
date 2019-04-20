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

	jsr hide_cursor_if_visible

	lda last_printed_character_ascii
	tax
	
	;; Check for special characters

	cmp #$00
	bne not_00
	jmp chrout_done
not_00:
	
	;; Linefeed (simply ignored)
	;; Trivia: BASIC does CRLF with READY. prompt
	cmp #$0a
	bne not_0a
	jmp chrout_done
not_0a:
	
	;; Carriage return
	cmp #$0d		
	beq screen_advance_to_next_line

	;; Check for cursor movement keys
	cmp #$11
	bne not_11
	inc current_screen_y
	jsr calculate_screen_line_pointer
	jmp chrout_done
not_11:	
	cmp #$1d
	bne not_1d
	inc current_screen_x
	jsr calculate_screen_line_pointer
	jmp chrout_done
not_1d:	
	
	cmp #$14
	bne not_14

	;; Delete
	ldx current_screen_x
	bne delete_non_zero_column
delete_at_column_0:
	ldy current_screen_y
	bne not_row_0
	;; delete from row 0, col 0 does nothing
	jmp chrout_done
not_row_0:
	dec current_screen_y
	lda screen_line_link_table,y
	bpl line_not_linked_del
	lda #79
	.byte $2c 		; BIT absolute mode, which we use to skip the next two instruction bytes
line_not_linked_del:
	lda #39
	sta current_screen_x
	jsr calculate_screen_line_pointer
	jmp chrout_done

delete_non_zero_column:	
	jmp chrout_done
	
not_14:	
	
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

	jsr calculate_screen_line_pointer
	
	;; Work out if we have gone off the bottom of the screen?
	;; 1040 > 1024, so if high byte of screen pointer is >= (HIBASE+4),
	;; then we are off the bottom of the screen
	lda current_screen_line_ptr+1
	sec
	sbc HIBASE
	cmp #3
	bcc +
	
	;; Off the bottom of the screen
	jsr scroll_screen_up

*
	jmp chrout_done

scroll_screen_up:
	;;  XXX - Not implemented
	rts
	
calculate_screen_line_pointer:
	;;  Reset pointer to start of screen
	lda HIBASE
	sta current_screen_line_ptr+1
	lda #0
	sta current_screen_line_ptr+0

	;; Add 40 for every line, or 80 if the lines are linked
	ldx current_screen_y
*
	;; Stop if we have counted enough lines
	beq +

	;; Add 40 or 80 based on whether the line is linked
	;; or not.
	ldy #40
	lda screen_line_link_table,x
	bpl cslp_l1
	ldy #80
cslp_l1:
	;; Add computed line length to pointer value
	tya
	clc
	adc current_screen_line_ptr+0
	sta current_screen_line_ptr+0
	lda current_screen_line_ptr+1
	adc #0
	sta current_screen_line_ptr+1
	
	;; Loop back to next line
	dex
	jmp -
*
	rts
	
	
retreat_screen_pointer_40_bytes:
	lda current_screen_line_ptr+0
	sec
	sbc #<40
	sta current_screen_line_ptr+0
	lda current_screen_line_ptr+1
	sbc #>40
	sta current_screen_line_ptr+1
	rts
	
advance_screen_pointer_40_bytes:
	lda current_screen_line_ptr+0
	clc
	adc #<40
	sta current_screen_line_ptr+0
	lda current_screen_line_ptr+1
	adc #>40
	sta current_screen_line_ptr+1
	rts
