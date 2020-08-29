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


// GFX/TXT switching support

m65_chrout_screen_GFX:

	lda VIC_YMCSB
	and #$02 // to upper case
!:
	sta VIC_YMCSB
	jmp_8 m65_chrout_screen_ctrl2_end

m65_chrout_screen_TXT:

	lda VIC_YMCSB
	ora #$02    // to lower case
	bne !-      // branch always
