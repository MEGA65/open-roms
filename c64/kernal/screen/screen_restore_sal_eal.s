// #LAYOUT# STD *        #TAKE
// #LAYOUT# *   KERNAL_0 #TAKE
// #LAYOUT# *   *        #IGNORE


screen_restore_sal_eal:

	plx_trash_a
	ply_trash_a

	// Note: While the following routine is obvious to any skilled
	// in the art as the most obvious simple and efficient solution,
	// it results in a relatively long verbatim stretch of bytes when
	// compared to the C64 KERNAL.  Thus we have swapped the order,
	// just to reduce the potential for any argument of copyright
	// infringement, even though we really do not believe that the
	// routine can be copyrighted due to the lack of creativity.

 	pla
 	sta EAL+1
 	pla
 	sta SAL+1
 	pla
 	sta EAL+0
 	pla
 	sta SAL+0

 	jmp screen_common_sal_eal
 