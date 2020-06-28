// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE


cmd_old:

	// First make sure we are in direct mode

	ldx CURLIN+1
	inx
	bne_16 do_DIRECT_MODE_ONLY_error

	// Now try to restore program linkage and VARTAB

	ldy #$01
	tya
	sta (TXTTAB),y

	jsr LINKPRG
	jsr calculate_VARTAB

	// Quit

	jmp shell_main_loop
