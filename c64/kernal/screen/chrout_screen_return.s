#if ROM_LAYOUT_STD || (ROM_LAYOUT_M65 && SEGMENT_KERNAL_0)

//
// RETURN key handling within CHROUT
//


chrout_screen_RETURN:

	// RETURN clears quote and insert modes, it also clears reverse flag
	
	lda #$00
	sta QTSW
	sta INSRT
	sta RVS

	// RETURN key moves cursor two lines down in case
	// of first line of the extended logical line
	
	ldy TBLX
	cpy #24
	beq !+                             // last line on screen - no need for a double line skip

	lda LDTBL+1, y
	bmi !+                             // current line is not continued

	inc TBLX
	jsr screen_calculate_PNT_USER
!:
	jmp screen_advance_to_next_line


#endif // ROM layout
