// #LAYOUT# M65 KERNAL_0 #TAKE
// #LAYOUT# *   *        #IGNORE

//
// ROM routine call redirect for MEGA65 screen routines
//


m65_chrout_screen:

	jsr     map_KERNAL_1
	jsr_ind VK1__m65_chrout_screen
	jsr     map_NORMAL
	jmp     chrout_done_success

m65_screen_upd_txtrow_off:

	jsr     map_KERNAL_1
	jsr_ind VK1__m65_screen_upd_txtrow_off
	jmp     map_NORMAL
