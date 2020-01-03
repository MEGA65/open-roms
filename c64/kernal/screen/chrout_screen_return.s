
//
// RETURN key handling within CHROUT
//


chrout_screen_RETURN:

	// RETURN clears quote and insert modes, it also clears reverse flag
	lda #$00
	sta QTSW
	sta INSRT
	sta RVS
	jmp screen_advance_to_next_line
