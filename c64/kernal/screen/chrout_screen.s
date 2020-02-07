// #LAYOUT# STD *        #TAKE
// #LAYOUT# X16 *        #IGNORE
// #LAYOUT# *   KERNAL_0 #TAKE
// #LAYOUT# *   *        #IGNORE

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
	jmp chrout_screen_literal // not high char

!:
	// Range $20-$3F is unchanged
	cmp #$40
	bcc chrout_screen_literal // not high char

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
	bcc chrout_screen_literal // not high char
	cmp #$40
	bcs chrout_screen_literal // not high char
	clc
	adc #$20

	// FALLTROUGH

chrout_screen_literal:

	// Write normal character on the screen

	tax                                // store screen code, we need .A for calculations

	// First we need offset from PNT in .Y, we can take it from PNTR

	jsr screen_get_clipped_PNTR

	// Put the character on the screen

	txa
	ora RVS                            // Computes Mapping the 64, page 38
	sta (PNT),y

	// Decrement number of chars waiting to be inserted

	lda INSRT
	beq !+
	dec INSRT
!:	
	// Toggle quote flag if required

	txa
	cmp #$22
	bne !+

	lda QTSW
	eor #$80
	sta QTSW
!:
	// Set colour of the newly printed character

	lda COLOR
	sta (USER),y

	// Advance the column

	ldy PNTR
	iny
	sty PNTR

	// Scroll down (extend logical line) if needed

	cpy #40
	bne !+
	jsr screen_grow_logical_line
	inc TBLX
	ldy PNTR
!:
	// If not the 80th character of the logical row, we are done

	cpy #80
	bcc chrout_screen_calc_lptr_done

	// Advance to the next line

	jmp screen_advance_to_next_line

chrout_screen_calc_lptr_done:

	jsr screen_calculate_pointers

	// FALLTROUGH

chrout_screen_done:

	jsr cursor_show_if_enabled
	jmp chrout_done_success
