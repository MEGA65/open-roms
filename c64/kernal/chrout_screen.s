
//
// CHROUT routine - screen support
//


chrout_screen:

	// Crude implementation of character output	
	sei // XXX why do we need to disable interrupts?

	jsr hide_cursor_if_visible

	lda SCHAR
	tax

	// Check for special characters

	cmp #$00
	bne not_00
	jmp chrout_done
not_00:

	// Linefeed (simply ignored)
	// Trivia: BASIC does CRLF with READY. prompt
	cmp #$0a
	bne not_0a
	jmp chrout_done
not_0a:

	// Carriage return
	cmp #$0d
	bne not_0d
	// RETURN clears quote and insert modes, it also clears reverse flag
	lda #$00
	sta QTSW
	sta INSRT
	sta RVS
	jmp screen_advance_to_next_line
not_0d:

	cmp #$94
	bne not_94

	// Insert (shift-DELETE)
	
	// Abort if line already max length, ie 79th char is not a space
	jsr get_current_line_logical_length
	cmp #79
	bne definitely_not_too_long
	tay
	lda (PNT),y
	cmp #$20
	beq definitely_not_too_long

	// Line is too long to extend
	jmp chrout_done

definitely_not_too_long:
	// Work out if line needs to be expanded, and if so expand it
	ldy #39
	lda (PNT),y
	cmp #$20
	beq no_need_to_extend

	jsr screen_grow_logical_line
	
no_need_to_extend:	
	// Shuffle chars towards end of line
	jsr get_current_line_logical_length
	tay
!:
	// Note: While the following routine is obvious to any skilled
	// in the art as the most obvious simple and efficient solution,
	// if the screen writes are before the colour writes, it results
	// in a relatively long verbatim stretch of bytes when compared to
	// the C64 KERNAL.  Thus we have swapped the order, just to reduce
	// the potential for any argument of copyright infringement, even
	// though we really don't believe that the routine can be copyrighted
	// due to the lack of creativity.
	dey
	lda (USER),y
	iny
	sta (USER),y
	dey
	lda (PNT),y
	iny
	sta (PNT),y

	dey
	cpy PNTR
	bne !-

	// Increase insert mode count (which causes quote-mode like behaviour)
	inc INSRT

	// Put space in the inserted gap
	lda #$20
	sta (PNT),y

	jmp chrout_done
not_94:	

	// DELETE in insert mode embeds control character
	ldx INSRT
	bne not_14

	cmp #$14
	bne not_14

	// Delete
	ldx PNTR
	bne delete_non_zero_column
delete_at_column_0:
	ldy TBLX
	bne not_row_0
	// delete from row 0, col 0 does nothing
	jmp chrout_done
not_row_0:
	// Column 0 delete just moves us to the end of the
	// previous line, without actually deleting anything
	dec TBLX
	jsr get_current_line_logical_length
	lda LNMX

	sta PNTR
	jsr calculate_screen_line_pointer
	jmp chrout_done

delete_non_zero_column:
	// Copy rest of line down
	jsr get_current_line_logical_length
	ldy PNTR
	cpy LNMX
	beq done_delete
	dey
!:
	iny
	lda (PNT),y
	dey
	sta (PNT),y
	iny
	lda (USER),y
	dey
	sta (USER),y
	iny
	cpy LNMX
	bne !-

	// Clear char at end of line
	jsr get_current_line_logical_length
	tay
	lda #$20
	sta (PNT),y

done_delete:
	dec PNTR
	jmp chrout_done
not_14:

	// Check for quote mode
	ldx QTSW
	bne is_quote_mode
	ldx INSRT
	bne is_quote_mode
	jmp not_quote_mode

is_quote_mode:	
	// Is it a control code?
	// control codes are $00-$1f and $80-$9f
	// (from reading C64 PRG p379-381)
	// so we can just check if bits 5 or 6 are set, and if so,
	// then it isn't a control character.
	pha
	and #$60
	bne !+

	// Yes, a control code in quote mode means we display it as a reverse character
	pla

	// Low control codes are just +$80
	clc
	adc #$80
	// If it overflowed, then it is a high control code,
	// so we need to make it be $80 + $40 + char
	// as we will have flipped back to just $00 + char, we should
	// now add $c0 if C is set from overflow
	bcc low_ctrl_char
	adc #$bf 		// C=1, so adding $BF + C = add $C0
low_ctrl_char:	
	jmp output_literal_char
!:
	pla
not_quote_mode:

	// Check for colours
	ldx #$f
colour_check_loop:	
	cmp colour_codes,x
	bne !+
	stx COLOR
	jmp chrout_done
!:	dex
	bpl colour_check_loop

	// Compute's Mapping the 64 p38
	cmp #$12
	bne not_12
	lda #$80
	sta RVS
	jmp chrout_done
not_12:
	// Compute's Mapping the 64 p 38	
	cmp #$92
	bne not_92
	lda #$00
	sta RVS
	jmp chrout_done
not_92:

	// Check for cursor movement keys
	cmp #$11
	bne not_11
	lda PNTR
	clc
	adc #40
	sta PNTR
	// We need to advance the pointer manually, as normalising
	// now will break things. The pointer update is required
	// so that we can tell if we really are on the bottom phys
	// screen line or not
	jsr scroll_up_if_on_last_line
	jsr calculate_screen_line_pointer
	jmp chrout_done
not_11:
	cmp #$1d
	bne not_1d
	inc PNTR
	jsr calculate_screen_line_pointer
	jmp chrout_done
not_1d:
	cmp #$91
	bne not_91
	lda PNTR
	sec
	sbc #40
	sta PNTR
	jsr calculate_screen_line_pointer
	jmp chrout_done
not_91:
	cmp #$9d
	bne not_9d
	dec PNTR
	jsr calculate_screen_line_pointer
	jmp chrout_done
not_9d:

	// Home cursor
	cmp #$13
	bne not_13
	lda #0
	sta PNTR
	sta TBLX
	jsr calculate_screen_line_pointer
	jmp chrout_done
not_13:	
	
	// Clear screen
	cmp #$93
	bne not_clearscreen
	jsr clear_screen
	jmp chrout_done
	
not_clearscreen:

	//  Convert PETSCII to screen code

	// Don't print other control codes
	cmp #$1f
	bcs !+
	jmp chrout_done
!:

	// Codes $C0-$DF become $40-$5F
	// But 
	cmp #$e0
	bcs !+
	cmp #$c0
	bcc !+
	
	and #$7f
	jmp output_literal_char // not high char

!:
	// Range $20-$3F is unchanged
	cmp #$40
	bcc output_literal_char // not high char

	// Unshifted letters and symbols from $40-$5F
	// all end up being -$40
	// (C64 PRG p376)

	// But anything >= $80 needs to be -$40
	// (C64 PRG p380-381)
	// And bit 7 should be cleared, only to be
	// set by reverse video
	sec
	sbc #$40

	// Fix shifted chars by adding $20 again
	cmp #$20
	bcc output_literal_char // not high char
	cmp #$40
	bcs output_literal_char // not high char
	clc
	adc #$20

output_literal_char:
	
	// Write normal character on the screen

	pha
	
	ldy PNTR
	ora RVS    // Compute's Mapping the 64  p38
	sta (PNT),y

	// Decrement number of chars waiting to be inserted
	lda INSRT
	beq !+
	dec INSRT
!:	
	pla
	cmp #$22
	bne not_quote

	//  Toggle quote flag if required
	lda QTSW
	eor #$80
	sta QTSW

not_quote:

	// Set colour
	lda COLOR
	sta (USER),y

	// Advance the column, and scroll screen down if we need
	// to insert a 2nd line in this logical line.
	// (eg Compute's Mapping the 64 p41)
	ldx TBLX
	iny
	sty PNTR
	cpy #40
	bne !+
	jsr screen_grow_logical_line
	ldy PNTR
!:
	cpy #80
	bcc no_screen_advance_to_next_line
	lda #0
	sta PNTR
	jmp screen_advance_to_next_line
no_screen_advance_to_next_line:
	jmp chrout_done

screen_grow_logical_line:
	ldy TBLX
	// Don't grow line if it is already grown
	lda LDTBL,y
	bpl !+
	jmp not_last_line // doneb grow line
!:
	lda #$80
	sta LDTBL,y

	// Now make space for the extra line added.
	// If we are on the last physical line of the screen,
	// Then we need to scroll the screen up
	jsr scroll_up_if_on_last_line
	
	// Scroll screen down to make space
	// As we are scrolling down, we start from the end,
	// and work backwards.  We can't be as simple and efficient
	// here as we are for scrolling up, because we don't know
	// how much must be scrolled.
	// Simple solution is to work out how many physical lines
	// need shifting down, and then move lines at a time after
	// initialising the pointers to the end area of the screen.
	ldx #25-2
	ldy #0
count_rows_loop:
	dex
	lda LDTBL,y
	bpl !+
	dex
!:	iny
	cpy TBLX
	bne count_rows_loop

	cpx #0
	beq no_copy_down
	bmi no_copy_down
	
	// Set pointers to end of screen line, and one line
	// above.  (It is always one physical line, because
	// this can only happen when expanding a line from 40 to
	// 80 characters).
	// XXX - This is not very efficient, and longer than it
	// needs to be. Better would be to work out size to
	// copy, and count it down in a pointer somewhere, so
	// that loop iteration logic is simpler.
	lda HIBASE
	clc
	adc #3
	sta PNT+1
	sta SAL+1
	lda #>$DBC0
	sta EAL+1
	sta USER+1

	lda #<$03C0
	sta PNT+0
	sta USER+0
	//  souce address is line above
	sec
	sbc #40
	sta SAL+0
	sta EAL+0

copy_line_down_loop:
	ldy #39
cl_inner:
	lda (EAL),y
	sta (USER),y
	lda (SAL),y
	sta (PNT),y
	dey
	bpl cl_inner

	// Decrement all pointers by 40
	// Low bytes are in common pairs

	// Old source is new destination
	// Use different registers to minimise byte similarity with C64 KERNAl
	ldy SAL+1
	sty PNT+1
	lda EAL+1
	ldy SAL+0
	sta USER+1
	sty PNT+0
	sty USER+0
	
	// Decrementing source pointers
	lda SAL+0
	sec
	sbc #<40
	sta SAL+0
	sta EAL+0
	lda SAL+1
	sbc #>40
	sta SAL+1
	// convert to screen equivalent
	sec
	sbc HIBASE
	clc
	adc #>$D800
	sta EAL+1

	dex
	bne copy_line_down_loop

no_copy_down:
	jsr calculate_screen_line_pointer

	// Erase newly inserted line
	ldy #79
!:
	lda COLOR
	sta (USER),y
	lda #$20
	sta (PNT),y
	dey
	cpy #40
	bne !-

	rts

not_last_line:
	rts

scroll_up_if_on_last_line:

	// Colour RAM is always in fixed place, so is easiest
	// to use to check if we are on the last line.
	// The last line is at $D800 + 24*40 = $DBC0
	lda USER+1
	cmp #>$DBC0
	bne not_last_line

	lda USER+0
	cmp #<$DBC0
	beq is_last_line

	jsr get_current_line_logical_length
	clc
	adc USER+0
	cmp #<$DBE7-1
	bcc not_last_line

is_last_line:

	dec TBLX

	// FALL THROUGH

scroll_screen_up:
	// Now scroll the whole screen up either one or two lines
	// based on whether the first screen line is linked or not.

	// Get pointers to start of screen + colour RAM
	lda HIBASE
	sta PNT+1
	sta SAL+1
	lda #>$D800
	sta USER+1
	sta EAL+1
	lda #$00
	sta PNT+0
	sta USER+0
	
	//  Get pointers to screen/colour RAM source
	lda LDTBL+0
	bmi !+
	lda #40
	.byte $2C 		// BIT $nnnn to skip next instruction
!:
	lda #80
	sta SAL+0
	sta EAL+0

	//  Copy first three pages
	ldy #$00
	ldx #3
scroll_copy_loop:
	lda (EAL),y
	sta (USER),y
	lda (SAL),y
	sta (PNT),y

	iny
	bne scroll_copy_loop

	inc SAL+1
	inc PNT+1
	inc EAL+1
	inc USER+1
	dex
	bne scroll_copy_loop

	// Copy last partial page
	// We need to copy 1000-(3*256)-line length
	// = 232 - line length
	lda SAL+0
	lda #232
	sec
	sbc SAL+0
	tax
scroll_copy_loop2:
 	lda (EAL),y
 	sta (USER),y
 	lda (SAL),y
 	sta (PNT),y
 	iny
 	dex
 	bne scroll_copy_loop2

	// Fill in scrolled up area
	ldx SAL+0
scroll_copy_loop3:
	lda COLOR
	sta (USER),y
	lda #$20
	sta (PNT),y
	iny
	dex
	bne scroll_copy_loop3

	// Shift line linkage list
	ldy #0
	ldx #24
link_copy:
	lda LDTBL+1,y
	sta LDTBL+0,y
	iny
	dex
	bne link_copy
	// Clear line link flag of last line
	stx LDTBL+24

	// Restore correct line pointers
	jsr calculate_screen_line_pointer

	rts

get_current_line_logical_length:
	ldy TBLX
	lda LDTBL,y
	bpl line_not_linked_del
	lda #79
	.byte $2c 		// BIT absolute mode, which we use to skip the next two instruction bytes
line_not_linked_del:
	lda #39
	sta LNMX
	rts

screen_advance_to_next_line:

	// jsr hide_cursor_if_visible
	
	//  Go to start of line
	lda #0
	sta PNTR
	//  Advance line number
	ldy TBLX

	// Do quick fix to line pointer to work out if it is off
	// the bottom of the screen.
	ldx #40
	lda LDTBL,y
	bmi !+
	.byte $2c
!:	ldx #80
	txa
	clc
	adc PNT+0
	sta PNT+0
	lda PNT+1
	adc #0
	sta PNT+1

	inc TBLX

	// Check if it will trigger scrolling
	// Work out if we have gone off the bottom of the screen?
	// 1040 > 1024, so if high byte of screen pointer is >= (HIBASE+4),
	// then we are off the bottom of the screen
	lda PNT+1
	sec
	sbc HIBASE
	cmp #3
	bcc !+
	lda PNT+0
	cmp #$e7
	bcc !+

	// Off the bottom of the screen
	jsr scroll_screen_up	
!:
	
	jsr calculate_screen_line_pointer
	
	jmp chrout_done

add_40_to_screen_x:
	lda PNTR
	clc
	adc #40
	sta PNTR
	rts

normalise_screen_x_y:	
	// Normalise X and Y values

	// If X < 0, then make X = X + 40 (or 80, if previous line is linked)
!:	lda PNTR
	bpl x_not_negative
	dec TBLX
	// Check that we didn't go backwards off the top of the screen
	bpl !+
	lda #0
	sta TBLX

!:	jsr add_40_to_screen_x

	// Check if line is linked, if so, add 40 again
	ldy TBLX
	lda LDTBL,y
	bpl !+
	jsr add_40_to_screen_x
!:

x_not_negative:
	// Work out if X is too big
	ldy TBLX
	lda LDTBL,y
	bpl !+
	lda #79
	.byte $2C 		// BIT $nnnn, used to skip next instruction
!:	lda #39
	cmp PNTR
	bcs x_not_too_big

	// X value is too big, so subtract 40 and increment Y
	lda PNTR
	sec
	sbc #40
	sta PNTR
	inc TBLX

x_not_too_big:

	// Make sure Y isn't negative
	lda TBLX
	bpl !+
	lda #0
	sta TBLX
!:
	// Make sure Y isn't too large for absolute size of
	// screen
	cmp #24
	bcc !+
	lda #24
	sta TBLX
!:
	// Make sure Y isn't too much for the screen, taking
	// into account the line link table
	ldy #24 		// max allowable line
	ldx #0
link_count_loop:
	lda LDTBL,x
	bpl !+
	dey
!:	inx
	cpx #25
	bne link_count_loop
	tya
	cmp TBLX
	bcs y_ok
	sta TBLX
y_ok:
	rts

calculate_screen_line_pointer:
	jsr normalise_screen_x_y
	
	//  Reset pointer to start of screen
	lda HIBASE
	sta PNT+1
	lda #0
	sta PNT+0

	// Add 40 for every line, or 80 if the lines are linked
	ldx TBLX

!:
	// Stop if we have counted enough lines
	beq !+

	// Add 40 or 80 based on whether the line is linked
	// or not.
	ldy #40
	// -1 offset is because we count down from N to 1, not
	// N-1 to 0.
	lda LDTBL-1,x
	bpl cslp_l1
	ldy #80
cslp_l1:
	// Add computed line length to pointer value
	tya
	clc
	adc PNT+0
	sta PNT+0
	lda PNT+1
	adc #0
	sta PNT+1
	
	// Loop back to next line
	dex
	jmp !-
!:

	// FALL THROUGH

update_colour_line_pointer:
	// Now setup pointer to colour RAM
	lda PNT+0
	sta USER+0
	lda PNT+1
	sec
	sbc HIBASE
	clc
	adc #>$d800
	sta USER+1

	rts

advance_screen_pointer_40_bytes:
	lda PNT+0
	clc
	adc #<40
	sta PNT+0
	sta USER+0
	lda PNT+1
	adc #>40
	sta PNT+1
	sec
	sbc HIBASE
	clc
	adc #>$D800
	sta USER+1

	jmp update_colour_line_pointer
