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
	php
	sei
	
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
	;; RETURN clears quote and insert modes
	lda #$00
	sta quote_mode_flag
	sta insert_mode
	jmp screen_advance_to_next_line
not_0d:	

	cmp #$94
	bne not_94

	;; Insert (shift-DELETE)
	
	;; Abort if line already max length, ie 79th char is not a space
	jsr get_current_line_logical_length
	cmp #79
	bne definitely_not_too_long
	tay
	lda (current_screen_line_ptr),y
	cmp #$20
	beq definitely_not_too_long

	;; Line is too long to extend
	jmp chrout_done

definitely_not_too_long:	
	;; Work out if line needs to be expanded, and if so expand it
	ldy #39
	lda (current_screen_line_ptr),y
	cmp #$20
	beq no_need_to_extend

	jsr screen_grow_logical_line
	
no_need_to_extend:	
	;; Shuffle chars towards end of line
	jsr get_current_line_logical_length
	tay
*
	;; Note: While the following routine is obvious to any skilled
	;; in the art as the most obvious simple and efficient solution,
	;; if the screen writes are before the colour writes, it results
	;; in a relatively long verbatim stretch of bytes when compared to
	;; the C64 KERNAL.  Thus we have swapped the order, just to reduce
	;; the potential for any argument of copyright infringement, even
	;; though we really don't believe that the routine can be copyrighted
	;; due to the lack of creativity.
	dey
	lda (current_screen_line_colour_ptr),y
	iny
	sta (current_screen_line_colour_ptr),y
	dey
	lda (current_screen_line_ptr),y
	iny
	sta (current_screen_line_ptr),y

	dey
	cpy current_screen_x
	bne -

	;; Increase insert mode count (which causes quote-mode like behaviour)
	inc insert_mode
	
	;; Put space in the inserted gap
	lda #$20
	sta (current_screen_line_ptr),y

	jmp chrout_done
not_94:	

	;; DELETE in insert mode embeds control character
	ldx insert_mode
	bne not_14
	
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
	;; Column 0 delete just moves us to the end of the
	;; previous line, without actually deleting anything
	dec current_screen_y
	jsr get_current_line_logical_length
	lda logical_line_length
	
	sta current_screen_x
	jsr calculate_screen_line_pointer
	jmp chrout_done

delete_non_zero_column:
	;; Copy rest of line down
	jsr get_current_line_logical_length
	ldy current_screen_x
	cpy logical_line_length
	beq done_delete
	dey
*
	iny
	lda (current_screen_line_ptr),y
	dey
	sta (current_screen_line_ptr),y
	iny
	lda (current_screen_line_colour_ptr),y
	dey
	sta (current_screen_line_colour_ptr),y
	iny
	cpy logical_line_length
	bne -

	;; Clear char at end of line
	jsr get_current_line_logical_length
	tay
	lda #$20
	sta (current_screen_line_ptr),y
	
done_delete:	
	dec current_screen_x
	jmp chrout_done	
not_14:	
	
	;; Check for quote mode
	ldx quote_mode_flag
	bne is_quote_mode
	ldx insert_mode
	bne is_quote_mode
	jmp not_quote_mode

is_quote_mode:	
	;; Is it a control code?
	;; control codes are $00-$1f and $80-$9f
	;; (from reading C64 PRG p379-381)
	;; so we can just check if bits 5 or 6 are set, and if so,
	;; then it isn't a control character.
	pha
	and #$60
	bne +

	;; Yes, a control code in quote mode means we display it as a reverse character
	pla

	;; Low control codes are just +$80
	clc
	adc #$80
	;; If it overflowed, then it is a high control code,
	;; so we need to make it be $80 + $40 + char
	;; as we will have flipped back to just $00 + char, we should
	;; now add $c0 if C is set from overflow
	bcc low_ctrl_char
	adc #$bf 		; C=1, so adding $BF + C = add $C0
low_ctrl_char:	
	jmp output_literal_char
*
	pla
not_quote_mode:	
	
	;; Check for colours
	ldx #$f
colour_check_loop:	
	cmp colour_codes,x
	bne +
	stx text_colour
	jmp chrout_done
	* dex
	bpl colour_check_loop

	;; Compute's Mapping the 64 p38
	cmp #$12
	bne not_12
	lda #$80
	sta reverse_video_flag
	jmp chrout_done
not_12:
	;; Compute's Mapping the 64 p 38	
	cmp #$92
	bne not_92
	lda #$00
	sta reverse_video_flag
	jmp chrout_done
not_92:	
	
	;; Check for cursor movement keys
	cmp #$11
	bne not_11
	lda current_screen_x
	clc
	adc #40
	sta current_screen_x
	;; We need to advance the pointer manually, as normalising
	;; now will break things. The pointer update is required
	;; so that we can tell if we really are on the bottom phys
	;; screen line or not
	jsr scroll_up_if_on_last_line
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
	lda current_screen_x
	sec
	sbc #40
	sta current_screen_x
	jsr calculate_screen_line_pointer
	jmp chrout_done
not_91:	
	cmp #$9d
	bne not_9d
	dec current_screen_x
	jsr calculate_screen_line_pointer
	jmp chrout_done
not_9d:	
		
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

	;; Don't print other control codes
	cmp #$1f
	bcs +
	jmp chrout_done
*

	;; Codes $C0-$DF become $40-$5F
	;; But 
	cmp #$e0
	bcs +
	cmp #$c0
	bcc +
	
	and #$7f
	jmp not_high_char

*
	;; Range $20-$3F is unchanged
	cmp #$40
	bcc not_high_char
	
	;; Unshifted letters and symbols from $40-$5F
	;; all end up being -$40
	;; (C64 PRG p376)

	;; But anything >= $80 needs to be -$40
	;; (C64 PRG p380-381)
	;; And bit 7 should be cleared, only to be
	;; set by reverse video
	sec
	sbc #$40

	;; Fix shifted chars by adding $20 again
	cmp #$20
	bcc not_high_char
	cmp #$40
	bcs not_high_char
	clc
	adc #$20

not_high_char:	

chrout_l1:
	
output_literal_char:	
	
	;; Write normal character on the screen

	pha
	
	ldy current_screen_x
	ora reverse_video_flag	; Compute's Mapping the 64  p38
	sta (current_screen_line_ptr),y

	;; Decrement number of chars waiting to be inserted
	lda insert_mode
	beq +
	dec insert_mode
*	
	pla
	cmp #$22
	bne not_quote

	;;  Toggle quote flag if required
	lda quote_mode_flag
	eor #$80
	sta quote_mode_flag

not_quote:	
	
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
	bne +
	jsr screen_grow_logical_line
	ldy current_screen_x
*
	cpy #80
	bcc no_screen_advance_to_next_line
	lda #0
	sta current_screen_x
	jmp screen_advance_to_next_line
no_screen_advance_to_next_line:

chrout_done:
	jsr show_cursor_if_enabled
	
	plp
	
	;; Restore X and Y, set carry to mark success on exit
	pla
	tay
	pla
	tax
	lda last_printed_character_ascii
	clc 			; indicate success
	rts

screen_grow_logical_line:
	ldy current_screen_y
	;; Don't grow line if it is already grown
	lda screen_line_link_table,y
	bmi done_grow_line
	
	lda #$80
	sta screen_line_link_table,y

	;; Now make space for the extra line added.
	;; If we are on the last physical line of the screen,
	;; Then we need to scroll the screen up
	jsr scroll_up_if_on_last_line
	
	;; Scroll screen down to make space
	;; As we are scrolling down, we start from the end,
	;; and work backwards.  We can't be as simple and efficient
	;; here as we are for scrolling up, because we don't know
	;; how much must be scrolled.
	;; Simple solution is to work out how many physical lines
	;; need shifting down, and then move lines at a time after
	;; initialising the pointers to the end area of the screen.
	ldx #25-2
	ldy #0
count_rows_loop:
	dex
	lda screen_line_link_table,y
	bpl +
	dex
*	iny
	cpy current_screen_y
	bne count_rows_loop

	cpx #0
	beq no_copy_down
	bmi no_copy_down
	
	;; Set pointers to end of screen line, and one line
	;; above.  (It is always one physical line, because
	;; this can only happen when expanding a line from 40 to
	;; 80 characters).
	;; XXX - This is not very efficient, and longer than it
	;; needs to be. Better would be to work out size to
	;; copy, and count it down in a pointer somewhere, so
	;; that loop iteration logic is simpler.
	lda HIBASE
	clc
	adc #3
	sta current_screen_line_ptr+1
	sta load_or_scroll_temp_pointer+1
	lda #>$DBC0
	sta load_save_verify_end_address+1
	sta current_screen_line_colour_ptr+1

	lda #<$03C0
	sta current_screen_line_ptr+0
	sta current_screen_line_colour_ptr+0
	;;  souce address is line above
	sec
	sbc #40
	sta load_or_scroll_temp_pointer+0
	sta load_save_verify_end_address+0

copy_line_down_loop:
	ldy #39
cl_inner:
	lda (load_save_verify_end_address),y
	sta (current_screen_line_colour_ptr),y
	lda (load_or_scroll_temp_pointer),y
	sta (current_screen_line_ptr),y
	dey
	bpl cl_inner

	;; Decrement all pointers by 40
	;; Low bytes are in common pairs

	;; Old source is new destination
	;; Use different registers to minimise byte similarity with C64 KERNAl
	ldy load_or_scroll_temp_pointer+1
	sty current_screen_line_ptr+1
	lda load_save_verify_end_address+1
	ldy load_or_scroll_temp_pointer+0
	sta current_screen_line_colour_ptr+1
	sty current_screen_line_ptr+0
	sty current_screen_line_colour_ptr+0
	
	;; Decrementing source pointers
	lda load_or_scroll_temp_pointer+0
	sec
	sbc #<40
	sta load_or_scroll_temp_pointer+0
	sta load_save_verify_end_address+0
	lda load_or_scroll_temp_pointer+1
	sbc #>40
	sta load_or_scroll_temp_pointer+1
	;; convert to screen equivalent
	sec
	sbc HIBASE
	clc
	adc #>$D800
	sta load_save_verify_end_address+1

	dex
	bne copy_line_down_loop

no_copy_down:	
	jsr calculate_screen_line_pointer

	;; Erase newly inserted line
	ldy #79
	*
	lda text_colour
	sta (current_screen_line_colour_ptr),y
	lda #$20
	sta (current_screen_line_ptr),y
	dey
	cpy #40
	bne -
	
	rts

done_grow_line:
not_last_line:	
	rts

scroll_up_if_on_last_line:

	;; Colour RAM is always in fixed place, so is easiest
	;; to use to check if we are on the last line.
	;; The last line is at $D800 + 24*40 = $DBC0
	lda current_screen_line_colour_ptr+1
	cmp #>$DBC0
	bne not_last_line

	lda current_screen_line_colour_ptr+0
	cmp #<$DBC0
	beq is_last_line
	
	jsr get_current_line_logical_length
	clc
	adc current_screen_line_colour_ptr+0
	cmp #<$DBE7-1
	bcc not_last_line	

is_last_line:	
	
	dec current_screen_y

	;; FALL THROUGH

scroll_screen_up:	
	;; Now scroll the whole screen up either one or two lines
	;; based on whether the first screen line is linked or not.

	;; Get pointers to start of screen + colour RAM
	lda HIBASE
	sta current_screen_line_ptr+1
	sta load_or_scroll_temp_pointer+1
	lda #>$D800
	sta current_screen_line_colour_ptr+1
	sta load_save_verify_end_address+1
	lda #$00
	sta current_screen_line_ptr+0
	sta current_screen_line_colour_ptr+0
	
	;;  Get pointers to screen/colour RAM source
	lda screen_line_link_table+0
	bmi +
	lda #40
	.byte $2C 		; BIT $nnnn to skip next instruction
	*
	lda #80
	sta load_or_scroll_temp_pointer+0
	sta load_save_verify_end_address+0

	;;  Copy first three pages
	ldy #$00
	ldx #3
scroll_copy_loop:
	lda (load_save_verify_end_address),y
	sta (current_screen_line_colour_ptr),y
	lda (load_or_scroll_temp_pointer),y
	sta (current_screen_line_ptr),y

	iny
	bne scroll_copy_loop

	inc load_or_scroll_temp_pointer+1
	inc current_screen_line_ptr+1
	inc load_save_verify_end_address+1
	inc current_screen_line_colour_ptr+1
	dex
	bne scroll_copy_loop

	;; Copy last partial page
	;; We need to copy 1000-(3*256)-line length
	;; = 232 - line length
	lda load_or_scroll_temp_pointer+0
	lda #232
	sec
	sbc load_or_scroll_temp_pointer+0
	tax
scroll_copy_loop2:		
 	lda (load_save_verify_end_address),y
 	sta (current_screen_line_colour_ptr),y
 	lda (load_or_scroll_temp_pointer),y
 	sta (current_screen_line_ptr),y
 	iny
 	dex
 	bne scroll_copy_loop2

	;; Fill in scrolled up area
	ldx load_or_scroll_temp_pointer+0
scroll_copy_loop3:
	lda text_colour
	sta (current_screen_line_colour_ptr),y
	lda #$20
	sta (current_screen_line_ptr),y
	iny
	dex
	bne scroll_copy_loop3
	
	;; Shift line linkage list
	ldy #0
	ldx #24
link_copy:
	lda screen_line_link_table+1,y
	sta screen_line_link_table+0,y
	iny
	dex
	bne link_copy
	;; Clear line link flag of last line
	stx screen_line_link_table+24

	;; Restore correct line pointers
	jsr calculate_screen_line_pointer

	rts
	
get_current_line_logical_length:	
	ldy current_screen_y
	lda screen_line_link_table,y
	bpl line_not_linked_del
	lda #79
	.byte $2c 		; BIT absolute mode, which we use to skip the next two instruction bytes
line_not_linked_del:
	lda #39
	sta logical_line_length
	rts
	
screen_advance_to_next_line:

	jsr hide_cursor_if_visible
	
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

add_40_to_screen_x:
	lda current_screen_x
	clc
	adc #40
	sta current_screen_x
	rts

normalise_screen_x_y:	
	;; Normalise X and Y values

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
	lda #79
	.byte $2C 		; BIT $nnnn, used to skip next instruction
*	lda #39
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
	;; into account the line link table
	ldy #24 		; max allowable line
	ldx #0
link_count_loop:	
	lda screen_line_link_table,x
	bpl +
	dey
*	inx
	cpx #25
	bne link_count_loop
	tya
	cmp current_screen_y
	bcs y_ok
	sta current_screen_y
y_ok:	
	
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
	;; -1 offset is because we count down from N to 1, not
	;; N-1 to 0.
	lda screen_line_link_table-1,x
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
	
	
advance_screen_pointer_40_bytes:
	lda current_screen_line_ptr+0
	clc
	adc #<40
	sta current_screen_line_ptr+0
	sta current_screen_line_colour_ptr+0
	lda current_screen_line_ptr+1
	adc #>40
	sta current_screen_line_ptr+1
	sec
	sbc HIBASE
	clc
	adc #>$D800
	sta current_screen_line_colour_ptr+1

	jmp update_colour_line_pointer
	
colour_codes:
	;; CHR$ codes for the 16 colours
	.byte 144,5,28,159,156,30,31,158
	.byte 129,149,150,151,152,153,154,155
