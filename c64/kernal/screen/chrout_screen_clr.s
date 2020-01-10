#if ROM_LAYOUT_STD || (ROM_LAYOUT_M65 && SEGMENT_KERNAL_0)

//
// CLR key handling within CHROUT
//


chrout_screen_CLR:

	jsr clear_screen
	jmp chrout_screen_calc_lptr_done


#endif // ROM layout
