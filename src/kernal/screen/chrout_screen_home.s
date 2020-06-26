// #LAYOUT# STD *        #TAKE
// #LAYOUT# X16 *        #IGNORE
// #LAYOUT# *   KERNAL_0 #TAKE
// #LAYOUT# *   *        #IGNORE

//
// HOME key handling within CHROUT
//


chrout_screen_HOME:

	jsr cursor_home
	jmp chrout_screen_calc_lptr_done
