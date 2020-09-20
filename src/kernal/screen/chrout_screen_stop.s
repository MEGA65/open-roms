;; #LAYOUT# STD *        #TAKE
;; #LAYOUT# X16 *        #IGNORE
;; #LAYOUT# *   KERNAL_0 #TAKE
;; #LAYOUT# *   *        #IGNORE

;
; STOP key handling within CHROUT
;


!ifdef CONFIG_EDIT_STOPQUOTE {


chrout_screen_STOP:
	
	lda #$00
	sta QTSW
	sta INSRT
	jmp chrout_screen_done
}
