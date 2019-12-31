
//
// RETURN key handling within CHROUT
//


chrout_screen_RETURN: /* YYY disabled for rework

	// RETURN clears quote and insert modes, it also clears reverse flag
	lda #$00
	sta QTSW
	sta INSRT
	sta RVS
	jmp chrout_screen_advance_to_next_line

*/
