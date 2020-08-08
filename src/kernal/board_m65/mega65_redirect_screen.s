// #LAYOUT# M65 KERNAL_0 #TAKE
// #LAYOUT# *   *        #IGNORE

//
// ROM routine call redirect for Mega65 screen routines
//


m65_chrout_screen:

	jsr     map_KERNAL_1
	jsr_ind VK1__m65_chrout_screen
	jsr     map_NORMAL
	jmp chrout_done_success

