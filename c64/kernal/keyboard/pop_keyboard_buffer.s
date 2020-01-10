#if ROM_LAYOUT_STD || (ROM_LAYOUT_M65 && SEGMENT_KERNAL_0)

// Pop key out of keyboard buffer
// Disable interrupts while reading from keyboard buffer
// so that no race conditions can occur
//
// CPU registers that has to be preserved: .X
//

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


#endif // ROM layout
