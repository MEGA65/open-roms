// #LAYOUT# M65 KERNAL_1 #TAKE
// #LAYOUT# *   *        #IGNORE


// Cursor movement

m65_chrout_screen_CRSR_RIGHT:

	inc M65__TXTCOL
	skip_2_bytes_trash_nvz

	// FALLTROUGH

m65_chrout_screen_CRSR_LEFT:
	
	dec M65__TXTCOL
	skip_2_bytes_trash_nvz

	// FALLTROUGH

m65_chrout_screen_CRSR_DOWN:

	inc M65__TXTROW
	skip_2_bytes_trash_nvz

	// FALLTROUGH

m65_chrout_screen_CRSR_UP:

	dec M65__TXTROW
	jmp_8 m65_chrout_screen_ctrl1_end


// 'RETURN' key

m65_chrout_screen_RETURN:

	// RETURN clears quote and insert modes, it also clears reverse flag
	
	lda #$00
	sta QTSW
	sta INSRT
	sta RVS

	// XXX should we clear special colour attributes too?

	// Move cursor to the beginning of the next line

	bit M64_SCRWINMODE
	bpl !+
	lda M65_TXTWIN_X0
	skip_2_bytes_trash_nvz
!:
	lda #$00
	sta M65__TXTCOL
	inc M65__TXTROW

	// FALLTROUGH

m65_chrout_screen_ctrl1_end:

	// Correct the column/row values

	jmp m65_chrout_fix_column_row
