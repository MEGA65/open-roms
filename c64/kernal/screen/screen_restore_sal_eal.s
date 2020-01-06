

screen_restore_sal_eal:

	plx_trash_a
	ply_trash_a

 	pla
 	sta EAL+1
 	pla
 	sta EAL+0
 	pla
 	sta SAL+1
 	pla
 	sta SAL+0

 	jmp screen_common_sal_eal
 