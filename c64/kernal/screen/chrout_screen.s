
//
// CHROUT routine - screen support (character output)
//


chrout_screen:

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
	bcc chrout_screen_done
	lda #0
	sta PNTR
	jmp chrout_screen_advance_to_next_line


chrout_screen_calc_lptr_done:

	jsr screen_calculate_line_pointer

	// FALLTROUGH

chrout_screen_done:

	jsr cursor_show_if_enabled
	jmp chrout_done_success
