#if ROM_LAYOUT_STD || (ROM_LAYOUT_M65 && SEGMENT_KERNAL_0)

//
// HOME key handling within CHROUT
//


chrout_screen_HOME:

	jsr cursor_home
	jmp chrout_screen_calc_lptr_done


#endif // ROM layout
