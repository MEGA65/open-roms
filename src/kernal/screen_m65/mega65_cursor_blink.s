// #LAYOUT# M65 KERNAL_0 #TAKE
// #LAYOUT# *   *        #IGNORE

//
// Variables used:
// - BLNSW (cursor blink switch)
// - BLNCT (cursor blink countdown)
// - GDBLN (cursor saved character)
// - BLNON (if cursor is visible)
// - GDCOL (colour under cursor)
//


m65_cursor_blink:

	// Preserve .Z
	phz

	// Is the cursor enabled?
	lda BLNSW
	bne m65_cursor_blink_end

	// Do we need to redraw things?
	dec BLNCT
	bpl m65_cursor_blink_end

	// Prepare .Z for offset within row
	ldz M65__TXTCOL

	// Prepare long pointer to color memory
	lda #$0F
	sta M65_LPNT_IRQ+3
	lda #$F8
	sta M65_LPNT_IRQ+2

	lda M65_COLVIEW+1
	sta M65_LPNT_IRQ+1
	lda M65_COLVIEW+0
	sta M65_LPNT_IRQ+0

	// Add screen row to the address
	ldy M65__TXTROW
	clc
	lda m65_scrtab_rowoffset_lo,y
	adc M65_LPNT_IRQ+0
	sta M65_LPNT_IRQ+0	
	lda m65_scrtab_rowoffset_hi,y
	adc M65_LPNT_IRQ+1
	sta M65_LPNT_IRQ+1	


	// Check if cursor was visible or not, and toggle
	lda BLNON
	bne m65_cursor_blink_undraw

	// FALLTROUGH

m65_cursor_blink_draw:

	lda #1
	sta BLNON

	// Cursor draw - color
	lda_lp (M65_LPNT_IRQ),z
	sta GDCOL
	lda COLOR
	and #$0F
	sta_lp (M65_LPNT_IRQ),z

	// Rework pointer to point to screnn memory
	jsr m65_cursor_blink_adapt_ptr

	// Cursor draw - character
	lda_lp (M65_LPNT_IRQ),z
	sta GDBLN
	eor #$80
	sta_lp (M65_LPNT_IRQ),z

m65_cursor_blink_timer_reset:

	// Rest blink counter (Mapping the 64, p39-40)
	lda #20
	sta BLNCT

	// FALLTROUGH

m65_cursor_blink_end:

	plz
	rts

m65_cursor_blink_undraw:

	lda #0
	sta BLNON

	// Cursor undraw - color
	lda GDCOL
	sta_lp (M65_LPNT_IRQ),z

	// Rework pointer to point to screnn memory
	jsr m65_cursor_blink_adapt_ptr

	// Cursor undraw - character
	lda GDBLN
	sta_lp (M65_LPNT_IRQ),z

	jmp_8 m65_cursor_blink_timer_reset


m65_cursor_blink_adapt_ptr:

	// Adapt pointer to point to screen memory

	lda M65_SCRSEG+1
	sta M65_LPNT_IRQ+3
	lda M65_SCRSEG+0
	sta M65_LPNT_IRQ+2

	clc
	lda M65_SCRBASE+0
	adc M65_LPNT_IRQ+0
	sta M65_LPNT_IRQ+0
	lda M65_SCRBASE+1
	adc M65_LPNT_IRQ+1
	sta M65_LPNT_IRQ+1

	rts
