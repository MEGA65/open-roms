;; #LAYOUT# STD *        #TAKE
;; #LAYOUT# *   KERNAL_0 #TAKE
;; #LAYOUT# *   *        #IGNORE

; Pop key out of keyboard buffer
; Disable interrupts while reading from keyboard buffer
; so that no race conditions can occur
;
; CPU registers that has to be preserved: .X
;

pop_keyboard_buffer:

	ldy #$01

	sei
@1:
	lda KEYD,y
	sta KEYD-1,y
	iny
	cpy XMAX
	bne @1
	dec NDX
	cli

	rts
