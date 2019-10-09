
//
// CHROUT routine - screen support
//


chrout_screen:

	// Crude implementation of character output	
	sei // XXX why do we need to disable interrupts?

	jsr cursor_hide_if_visible

	lda SCHAR
	tax

	// All the PETSCII control codes are within $0x, $1x, $8x, $9x, remaining
	// ones are always printable characters; separate away control codes

	and #$60
	bne !+
	jmp chrout_screen_control
!:
	txa

	// Literals - first convert PETSCII to screen code

	// Codes $C0-$DF become $40-$5F
	cmp #$E0
	bcs !+
	cmp #$C0
	bcc !+
	
	and #$7F
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

	// jsr cursor_hide_if_visible
	
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
