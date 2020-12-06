;; #LAYOUT# M65 KERNAL_0 #TAKE
;; #LAYOUT# *   *        #IGNORE


m65_scnkey_init_pressed:

	lda #$FF
	sta M65_KB_PRESSED+0
	sta M65_KB_PRESSED+1
	sta M65_KB_PRESSED+2
	sta M65_KB_PRESSED_NEW+0
	sta M65_KB_PRESSED_NEW+1
	sta M65_KB_PRESSED_NEW+2

	rts
