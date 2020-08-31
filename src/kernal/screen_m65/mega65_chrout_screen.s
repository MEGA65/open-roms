// #LAYOUT# M65 KERNAL_1 #TAKE
// #LAYOUT# *   *        #IGNORE

//
// CHROUT routine - screen support (character output), MEGA65 native mode version
//


m65_chrout_screen:

	jsr m65_cursor_hide_if_visible

	// Retrieve the character to output

	lda SCHAR
	tax

	// All the PETSCII control codes are within $0x, $1x, $8x, $9x, remaining
	// ones are always printable characters; separate away control codes

	and #$60
	beq_16 m65_chrout_screen_control
	txa

	// Literals - first convert PETSCII to screen code

	jsr chrout_to_screen_code

	// FALLTROUGH

m65_chrout_screen_literal: // entry point for m65_chrout_screen_quote

	// Write normal character on the screen

	tax                                // store screen code, we need .A for calculations

	// Preserve .Z on stack

	phz

	// Prepare .Z and M65_LPNT_SCR for colour memory manipulation

	ldz M65__TXTCOL
	jsr m65_helper_scrlpnt_color

	// Store the new color in screen memory

	lda COLOR
	sta_lp (M65_LPNT_SCR),z

	// Now change M65_LPNT_SCR to point to screen memory

	jsr m65_helper_scrlpnt_to_screen

	// Decrement number of chars waiting to be inserted

	lda INSRT
	beq !+
	dec INSRT
!:
	// Toggle quote flag if required

	txa
	jsr screen_check_toggle_quote

	// Store the new character in screen memory, restore .Z

	txa

	bit RVS
	bpl !+
	ora #$80                           // reverse the character  XXX consider doing this within chrout_to_screen_code
!:
	sta_lp (M65_LPNT_SCR),z
	
	// Restore .Z

	plz

	// Increment screen column by 1

	inc M65__TXTCOL

	// FALLTROUGH

m65_chrout_fix_column_row:

	ldy M65_SCRMODE

	bit M65_SCRWINMODE
	bmi m65_chrout_fix_column_row_win

	// Non-windowed mode

	// Check for column below 0

	lda M65__TXTCOL
	bpl !++

	lda M65_COLVIEW+0
	ora M65_COLVIEW+1
	ora M65__TXTROW
	bne !+
	lda #$00
	sta M65__TXTCOL
	jmp_8 !++
!:
	dec M65__TXTROW
	lda m65_scrtab_txtwidth,y
	sta M65__TXTCOL
	dec M65__TXTCOL
!:
	// Check for column above maximum

	lda M65__TXTCOL
	cmp m65_scrtab_txtwidth,y
	bcc !+

	inc M65__TXTROW
	lda #$00
	sta M65__TXTCOL
!:
	// Check for row below 0

	lda M65__TXTROW
	bpl !+

	jsr m65_chrout_fix_scroll_down
!:
	// Check for row above maximum

	lda M65__TXTROW
	cmp m65_scrtab_txtheight,y
	bcc !+

	jsr m65_chrout_fix_scroll_up
!:
	jmp_8 m65_chrout_fix_txtrow_off

m65_chrout_fix_column_row_win:

	// Windowed mode

	// XXX
	// XXX provide implementation
	// XXX

	nop

	// FALLTROUGH

m65_chrout_fix_txtrow_off:

	jsr m65_screen_upd_txtrow_off

	// FALLTROUGH

m65_chrout_screen_done:

	jsr cursor_show_if_enabled

	// XXX make sure it return success
	rts



// Try to fix coordinates by scrolling the screen down

m65_chrout_fix_scroll_down:

	inc M65__TXTROW

	// Check if we can simply adapt the viewport

	lda M65_COLVIEW+0
	ora M65_COLVIEW+1
	beq m65_chrout_fix_scroll_down_end

	// Yes, we can simply adapt the viewport

	sec
	lda M65_COLVIEW+0
	sbc #$50
	sta M65_COLVIEW+0
	sta VIC_COLPTR+0
	bcs !+
	dec M65_COLVIEW+1
	dec VIC_COLPTR+1
!:
	sec
	lda VIC_SCRNPTR+0
	sbc #$50
	sta VIC_SCRNPTR+0
	bcs !+
	dec VIC_SCRNPTR+1
!:
	// FALLTROUGH

m65_chrout_fix_scroll_down_end:

	rts


// Try to fix coordinates by scrolling the screen up

m65_chrout_fix_scroll_up:

	dec M65__TXTROW

	// Check if we can simply adapt the viewport

	lda M65_COLVIEW+1
	cmp M65_COLVIEWMAX+1
	bne !+

	lda M65_COLVIEW+0
	cmp M65_COLVIEWMAX+0
	beq m65_chrout_fix_scroll_up_scroll
!:
	// Yes, we can simply adapt the viewport

	clc
	lda M65_COLVIEW+0
	adc #$50
	sta M65_COLVIEW+0
	sta VIC_COLPTR+0
	bcc !+
	inc M65_COLVIEW+1
	inc VIC_COLPTR+1
!:
	clc
	lda VIC_SCRNPTR+0
	adc #$50
	sta VIC_SCRNPTR+0
	bcc !+
	inc VIC_SCRNPTR+1
!:
	rts

m65_chrout_fix_scroll_up_scroll:

	// Virtual screen is too small - we will lose one row

	// Calculate size of data to copy

	sec
	lda M65_COLGUARD+0
	sbc #$50
	sta M65_DMAJOB_SIZE_0
	lda M65_COLGUARD+1
	sbc #$00
	sta M65_DMAJOB_SIZE_1

	// Scroll up screen memory

	jsr m65_screen_dmasrcdst_screen
	jsr m65_screen_dmasrc_add_row
	jsr m65_dmagic_oper_copy

	// Scroll up color memory

	jsr m65_screen_dmasrcdst_color
	jsr m65_screen_dmasrc_add_row
	jsr m65_dmagic_oper_copy

	// Clear the last row - color and screen memory

	phz

	jsr m65_helper_scrlpnt_color
	lda COLOR
	and #$0F
	ldz #$4F
!:
	sta_lp (M65_LPNT_SCR), z
	dez
	bpl !-

	jsr m65_helper_scrlpnt_to_screen
	lda #$20
	ldz #$4F
!:
	sta_lp (M65_LPNT_SCR), z
	dez
	bpl !-

	plz

	rts
