;; #LAYOUT# M65 KERNAL_1 #TAKE
;; #LAYOUT# *   *        #IGNORE


; Cursor movement

m65_chrout_screen_CRSR_RIGHT:

	inc M65__TXTCOL
	+skip_2_bytes_trash_nvz

	; FALLTROUGH

m65_chrout_screen_CRSR_LEFT:
	
	dec M65__TXTCOL
	+skip_2_bytes_trash_nvz

	; FALLTROUGH

m65_chrout_screen_CRSR_DOWN:

	inc M65__TXTROW
	+skip_2_bytes_trash_nvz

	; FALLTROUGH

m65_chrout_screen_CRSR_UP:

	dec M65__TXTROW
	bra m65_chrout_screen_ctrl1_end


; 'RETURN' key

m65_chrout_screen_RETURN:

	; RETURN clears quote and insert modes, it also clears reverse flag
	
	jsr m65_screen_clear_special_modes

	; Move cursor to the beginning of the next line

	bit M65_SCRWINMODE
	bpl @1
	lda M65_TXTWIN_X0
	+skip_2_bytes_trash_nvz
@1:
	lda #$00
	sta M65__TXTCOL
	inc M65__TXTROW

	; FALLTROUGH

m65_chrout_screen_ctrl1_end:

	; Correct the column/row values

	jmp m65_chrout_fix_column_row
