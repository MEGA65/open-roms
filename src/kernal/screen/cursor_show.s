;; #LAYOUT# STD *        #TAKE
;; #LAYOUT# X16 *        #IGNORE
;; #LAYOUT# *   KERNAL_0 #TAKE
;; #LAYOUT# *   *        #IGNORE

;
; Variables used:
; - BLNSW (cursor blink switch)
; - BLNON (if cursor is visible)
; - BLNCT (cursor blink countdown)
;


cursor_show_if_enabled:

	lda BLNSW
	bne cursor_show_done
	lda BLNON
	bne cursor_show_done

	; FALLTROUGH

cursor_show:

	; Set the cursor so that it is going to be repainted by the next IRQ

	lda #$01
	sta BLNCT

	lda #$00
	sta BLNON

	; FALLTROUGH

cursor_show_done:

	rts
