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
	bne not_0d
	jmp screen_advance_to_next_line
not_0d:	

	;; Check for quote mode

	;; Check for colours
	ldx #$f
colour_check_loop:	
	cmp colour_codes,x
	bne +
	stx text_colour
	jmp chrout_done
	* dex
	bpl colour_check_loop
	
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
	cmp #$91
	bne not_91
	dec current_screen_y
	jsr calculate_screen_line_pointer
	jmp chrout_done
not_91:	
	cmp #$9d
	bne not_9d
	dec current_screen_x
	jsr calculate_screen_line_pointer
	jmp chrout_done
not_9d:	
	
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
	jsr get_current_line_logical_length
	
	sta current_screen_x
	jsr calculate_screen_line_pointer
	jmp chrout_done

delete_non_zero_column:
	;; Copy rest of line down
	jsr get_current_line_logical_length
	ldy current_screen_x
*
	lda (current_screen_line_ptr),y
	dey
	sta (current_screen_line_ptr),y
	iny
	lda (current_screen_line_colour_ptr),y
	dey
	sta (current_screen_line_colour_ptr),y
	iny
	iny
	cpy logical_line_length
	bne -

	dec current_screen_x
	
	jmp chrout_done
	
not_14:	

	;; Home cursor
	cmp #$13
	bne not_13
	lda #0
	sta current_screen_x
	sta current_screen_y
	jsr calculate_screen_line_pointer
	jmp chrout_done
not_13:	
	
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

	;; Set colour
	lda text_colour
	sta (current_screen_line_colour_ptr),y

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
	;; Make cursor immediately visible
	jsr show_cursor
	
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

get_current_line_logical_length:	
	ldy current_screen_y
	lda screen_line_link_table,y
	bpl line_not_linked_del
	lda #79
	.byte $2c 		; BIT absolute mode, which we use to skip the next two instruction bytes
line_not_linked_del:
	lda #39
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

add_40_to_screen_x:
	lda current_screen_x
	clc
	adc #40
	sta current_screen_x
	rts

normalise_screen_x_y:	
	;; Normalise X and Y values

	;; lda current_screen_x
	;; sta $0400
	;; lda current_screen_y
	;; sta $0401
	
	;; If X < 0, then make X = X + 40 (or 80, if previous line is linked)
*	lda current_screen_x
	bpl x_not_negative
	dec current_screen_y
	;; Check that we didn't go backwards off the top of the screen
	bpl +
	lda #0
	sta current_screen_y

*	jsr add_40_to_screen_x

	;; Check if line is linked, if so, add 40 again
	ldy current_screen_y
	lda screen_line_link_table,y
	bpl +
	jsr add_40_to_screen_x
*

x_not_negative:
	;; Work out if X is too big
	ldy current_screen_y
	lda screen_line_link_table,y
	bpl +
	lda #80
	.byte $2C 		; BIT $nnnn, used to skip next instruction
*	lda #40
	cmp current_screen_x
	bcs x_not_too_big

	;; X value is too big, so subtract 40 and increment Y
	lda current_screen_x
	sec
	sbc #40
	sta current_screen_x
	inc current_screen_y

x_not_too_big:	

	;; Make sure Y isn't negative
	lda current_screen_y
	bpl +
	lda #0
	sta current_screen_y
*
	;; Make sure Y isn't too large for absolute size of
	;; screen
	cmp #24
	bcc +
	lda #24
	sta current_screen_y
*
	;; Make sure Y isn't too much for the screen, taking
	;; into account 

	
	;; lda current_screen_x
	;; sta $0403
	;; lda current_screen_y
	;; sta $0404
	rts

calculate_screen_line_pointer:
	jsr normalise_screen_x_y
	
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

	;; FALL THROUGH

update_colour_line_pointer:	
	;; Now setup pointer to colour RAM
	lda current_screen_line_ptr+0
	sta current_screen_line_colour_ptr+0
	lda current_screen_line_ptr+1
	sec
	sbc HIBASE
	clc
	adc #>$d800
	sta current_screen_line_colour_ptr+1
	
	rts
	
	
retreat_screen_pointer_40_bytes:
	lda current_screen_line_ptr+0
	sec
	sbc #<40
	sta current_screen_line_ptr+0
	lda current_screen_line_ptr+1
	sbc #>40
	sta current_screen_line_ptr+1

	jmp update_colour_line_pointer
	
advance_screen_pointer_40_bytes:
	lda current_screen_line_ptr+0
	clc
	adc #<40
	sta current_screen_line_ptr+0
	lda current_screen_line_ptr+1
	adc #>40
	sta current_screen_line_ptr+1

	jmp update_colour_line_pointer
	
colour_codes:
	;; CHR$ codes for the 16 colours
	.byte 144,5,28,159,156,30,31,158
	.byte 129,149,150,151,152,153,154,155
