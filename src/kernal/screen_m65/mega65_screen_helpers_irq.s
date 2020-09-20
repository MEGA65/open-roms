;; #LAYOUT# M65 KERNAL_0 #TAKE
;; #LAYOUT# *   *        #IGNORE


m65_cursor_blink_irqpnt_to_screen:

	; Adapt pointer to point to screen memory

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
