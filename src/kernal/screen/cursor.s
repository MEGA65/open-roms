;; #LAYOUT# STD *        #TAKE
;; #LAYOUT# X16 *        #IGNORE
;; #LAYOUT# *   KERNAL_0 #TAKE
;; #LAYOUT# *   *        #IGNORE

;
; Variables used:
; - BLNSW (cursor blink switch)
; - BLNCT (cursor blink countdown)
; - GDBLN (cursor saved character)
; - BLNON (if cursor is visible)
; - GDCOL (colour under cursor)
; - USER  (current screen line colour pointer)
; - PNT   (current screen line pointer)
; - PNTR  (current screen x position)
;


cursor_blink:

	; Is the cursor enabled?
	lda BLNSW
	bne cursor_blink_end

	; Do we need to redraw things?
	dec BLNCT
	bpl cursor_blink_end

	; Check if cursor was visible or not, and toggle
	lda BLNON
	bne cursor_undraw

	; FALLTROUGH

cursor_draw:

	jsr screen_get_clipped_PNTR
	lda (PNT),y
	sta GDBLN
	eor #$80
	sta (PNT),y
	; Also set cursor colour
	lda (USER),y
	sta GDCOL
	lda COLOR
	sta (USER),y

	lda #1
	sta BLNON

	bne cursor_timer_reset ; branches always


; XXX code below is probably not 100% safe

cursor_disable:

	lda #$80
	sta BLNSW

	; FALLTHROUGH

cursor_hide_if_visible:

	; Set countdown to high value, to prevent IRQ interference
	lda #$FF
	sta BLNCT

	; If cursor is not visible, not much to do
	lda BLNON
	beq cursor_timer_reset

	; FALLTROUGH

cursor_undraw:

	jsr screen_get_clipped_PNTR
	lda GDBLN
	sta (PNT),y
	lda GDCOL
	sta (USER),y
	
	; FALLTROUGH

cursor_undraw_cont: ; entry point used by MEGA65 screen editor

	; Mark cursor as not drawn
	lda #0
	sta BLNON

	; FALLTROUGH

cursor_timer_reset:

	; Rest blink counter (Mapping the 64, p39-40)
	lda #20
	sta BLNCT

	; FALLTROUGH

cursor_blink_end:

	rts
