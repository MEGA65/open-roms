#if ROM_LAYOUT_STD || (ROM_LAYOUT_M65 && SEGMENT_KERNAL_0)

//
// STOP key handling within CHROUT
//


#if CONFIG_EDIT_STOPQUOTE


chrout_screen_STOP:
	
	lda #$00
	sta QTSW
	sta INSRT
	jmp chrout_screen_done


#endif


#endif // ROM layout
