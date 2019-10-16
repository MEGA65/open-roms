
// Pop key out of keyboard buffer
// Disable interrupts while reading from keyboard buffer
// so that no race conditions can occur


pop_keyboard_buffer:

	ldy #$01

	sei
!:	lda KEYD,y
	sta KEYD-1,y
	iny
	cpy XMAX
	bne !-
	dec NDX
	cli

	rts
