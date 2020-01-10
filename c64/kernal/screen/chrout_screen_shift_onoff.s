#if ROM_LAYOUT_STD || (ROM_LAYOUT_M65 && SEGMENT_KERNAL_0)

//
// SHIFT ON/OFF handling within CHROUT
//


chrout_screen_SHIFT_ON:

	lda #$00 // enable SHIFT+VENDOR combination
!:
	sta MODE
	jmp chrout_screen_done

chrout_screen_SHIFT_OFF:

	lda #$80 // disable SHIFT+VENDOR combination
	bne !-   // branch always


#endif // ROM layout
