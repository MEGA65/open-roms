// #LAYOUT# M65 KERNAL_1 #TAKE
// #LAYOUT# *   *        #IGNORE


// 'REVERSE' mode support

m65_chrout_screen_RVS_ON:

	lda #$80
	skip_2_bytes_trash_nvz

	// FALLTROUGH

m65_chrout_screen_RVS_OFF:

	lda #$00

	sta RVS

	// FALLTROUGH

m65_chrout_screen_ctrl2_end:

	jmp m65_chrout_screen_done


// 'SHIFT ON/OFF' support

m65_chrout_screen_SHIFT_ON:

	lda #$00 // enable SHIFT+VENDOR combination
	skip_2_bytes_trash_nvz

	// FALLTROUGH

m65_chrout_screen_SHIFT_OFF:

	lda #$80 // disable SHIFT+VENDOR combination

	sta MODE
	jmp_8 m65_chrout_screen_ctrl2_end


// STOP key support

m65_chrout_screen_STOP:

	lda #$00
	sta QTSW
	sta INSRT
	jmp_8 m65_chrout_screen_ctrl2_end

// CLR/HOME key support

m65_chrout_screen_CLR:

	jsr M65_CLRWIN
	jmp_8 m65_chrout_screen_ctrl2_end

m65_chrout_screen_HOME:

	jsr M65_HOME
	jmp_8 m65_chrout_screen_ctrl2_end

// INS key

m65_chrout_screen_INS:

	// First prepare the pointer to the current row

	jsr m65_helper_scrlpnt_color
	jsr m65_helper_scrlpnt_to_screen

	// Check for windowed mode

	lda M65_SCRWINMODE
	bmi_16 m65_chrout_screen_INS_winmode

	// Check if last character of the line is space

	ldy M65_SCRMODE
	lda m65_scrtab_txtwidth,y
	dec_a
	taz
	lda_lp (M65_LPNT_SCR), z
	cmp #$20
	bne_16 m65_chrout_screen_ctrl2_end
	phz

	// Last character is space - move the characters

	jsr m65_chrout_screen_INS_copy

	// Store space in the current character cell

	lda #$20
	sta_lp (M65_LPNT_SCR), z

	// Move the color memory

	jsr m65_helper_scrlpnt_color
	plz
	jsr m65_chrout_screen_INS_copy

	// Store current colour in the current character cell

	lda COLOR
	and #$0F
	sta_lp (M65_LPNT_SCR), z

	// Increase insert mode count (which causes quote-mode like behaviour) and quit

	inc INSRT
	jmp_8 m65_chrout_screen_ctrl2_end

m65_chrout_screen_INS_winmode:

	// Check if last character of the line within window is space

	// XXX provide implementation

	jmp_8 m65_chrout_screen_ctrl2_end



m65_chrout_screen_INS_copy:

	dez
	lda_lp (M65_LPNT_SCR), z
	inz
	sta_lp (M65_LPNT_SCR), z
	dez
	cpz M65__TXTCOL
	bne m65_chrout_screen_INS_copy

	rts
