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

	// Prepare .Z and long pointer to screen position
	ldz M65__TXTCOL
	lda M65_SCRVIEW+0
	sta M65_LPNT_IRQ+0
	lda M65_SCRVIEW+1
	sta M65_LPNT_IRQ+1
	lda M65_SCRSEG+0
	sta M65_LPNT_IRQ+2
	lda M65_SCRSEG+1
	sta M65_LPNT_IRQ+3

	// Add row offset to the long pointer
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

	// Cursor draw - character
	lda_lp (M65_LPNT_IRQ),z
	sta GDBLN
	eor #$80
	sta_lp (M65_LPNT_IRQ),z

	// Cursor draw - color
	// XXX provide implementation

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

	// Cursor undraw - character
	lda GDBLN
	sta_lp (M65_LPNT_IRQ),z

	// Cursor undraw - color
	// XXX provide implementation

	jmp_8 m65_cursor_blink_timer_reset
