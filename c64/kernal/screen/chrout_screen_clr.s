// #LAYOUT# STD *        #TAKE
// #LAYOUT# X16 *        #IGNORE
// #LAYOUT# *   KERNAL_0 #TAKE
// #LAYOUT# *   *        #IGNORE

//
// CLR key handling within CHROUT
//


chrout_screen_CLR:

	jsr clear_screen
	jmp chrout_screen_calc_lptr_done
