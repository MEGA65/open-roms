;; #LAYOUT# M65 KERNAL_C #TAKE
;; #LAYOUT# *   *        #IGNORE

;
; Variables used:
; - BLNSW (cursor blink switch)
; - BLNCT (cursor blink countdown)
; - GDBLN (cursor saved character)
; - BLNON (if cursor is visible)
; - GDCOL (colour under cursor)
;


m65_cursor_blink:

	; Preserve .Z
	phz

	; Is the cursor enabled?
	lda BLNSW
	bne m65_cursor_blink_end

	; Do we need to redraw things?
	dec BLNCT
	bpl m65_cursor_blink_end

	; Prepare .Z for offset within row
	ldz M65__TXTCOL

	; Prepare long pointer to color memory
	lda #$0F
	sta M65_LPNT_IRQ+3
	lda #$F8
	sta M65_LPNT_IRQ+2

	lda M65_COLVIEW+1
	sta M65_LPNT_IRQ+1
	lda M65_COLVIEW+0
	sta M65_LPNT_IRQ+0

	; Add screen row to the address
	clc
	lda M65_TXTROW_OFF+0
	adc M65_LPNT_IRQ+0
	sta M65_LPNT_IRQ+0	
	lda M65_TXTROW_OFF+1
	adc M65_LPNT_IRQ+1
	sta M65_LPNT_IRQ+1	

	; Check if cursor was visible or not, and toggle
	lda BLNON
	bne m65_cursor_blink_check_undraw

	; FALLTROUGH

m65_cursor_blink_draw:

	lda #1
	sta BLNON

	; Cursor draw - color
	lda [M65_LPNT_IRQ],z
	sta GDCOL
	lda COLOR
	and #$0F                           ; take current colour, but not extended attributes
	sta [M65_LPNT_IRQ],z

	; Cursor draw - character
	jsr m65_cursor_blink_irqpnt_to_screen
	lda [M65_LPNT_IRQ],z
	sta GDBLN
	eor #$80
	sta [M65_LPNT_IRQ],z

m65_cursor_blink_timer_reset:

	; Rest blink counter (Mapping the 64, p39-40)
	lda #20
	sta BLNCT

	; FALLTROUGH

m65_cursor_blink_end:

	plz
	rts

m65_cursor_blink_check_undraw:

	; Check if cursor should blink at all
	lda M65_SOLIDCRSR
	bne m65_cursor_blink_timer_reset

	; Cursor undraw - color
	lda GDCOL
	sta [M65_LPNT_IRQ],z

	; Cursor undraw - character
	jsr m65_cursor_blink_irqpnt_to_screen
	lda GDBLN
	sta [M65_LPNT_IRQ],z

	; Mark cursor as not drawn
	lda #0
	sta BLNON

	bra m65_cursor_blink_timer_reset
