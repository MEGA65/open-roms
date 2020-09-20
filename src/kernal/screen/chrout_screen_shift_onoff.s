;; #LAYOUT# STD *        #TAKE
;; #LAYOUT# X16 *        #IGNORE
;; #LAYOUT# *   KERNAL_0 #TAKE
;; #LAYOUT# *   *        #IGNORE

;
; SHIFT ON/OFF handling within CHROUT
;


chrout_screen_SHIFT_ON:

	lda #$00 ; enable SHIFT+VENDOR combination
	+skip_2_bytes_trash_nvz

	; FALLTROUGH

chrout_screen_SHIFT_OFF:

	lda #$80 ; disable SHIFT+VENDOR combination

	sta MODE
	jmp chrout_screen_done
