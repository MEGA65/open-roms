// #LAYOUT# STD *        #TAKE
// #LAYOUT# X16 *        #IGNORE
// #LAYOUT# *   KERNAL_0 #TAKE
// #LAYOUT# *   *        #IGNORE

//
// Routine to unhide Mega65 extra registers
//


#if CONFIG_KEYBOARD_C65 || (CONFIG_MB_MEGA_65 && (CONFIG_TAPE_NORMAL || CONFIG_TAPE_TURBO))


mega65_unhide:

	lda #$A5
	sta VIC_KEY
	lda #$96
	sta VIC_KEY

	rts


#endif
