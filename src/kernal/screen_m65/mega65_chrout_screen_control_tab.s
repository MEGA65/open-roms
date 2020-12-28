;; #LAYOUT# M65 KERNAL_1 #TAKE
;; #LAYOUT# *   *        #IGNORE


; XXX: implement screen routines below:

m65_chrout_esc_Y: ; set default TAB stops
	+nop
m65_chrout_esc_Z: ; clear all the TAB stops
	+nop
m65_chrout_screen_TAB:
	+nop
m65_chrout_screen_TAB_SET_CLR:

	jmp m65_chrout_screen_done
