;; #LAYOUT# M65 KERNAL_1 #TAKE
;; #LAYOUT# *   *        #IGNORE


m65_helper_scrlpnt_color:

	; Setting M65_LPNT_SCR to point to colour memory (starts from $FF80000)

	lda #$0F
	sta M65_LPNT_SCR+3
	lda #$F8
	sta M65_LPNT_SCR+2

	lda M65_COLVIEW+1
	sta M65_LPNT_SCR+1
	lda M65_COLVIEW+0
	sta M65_LPNT_SCR+0

	; Add screen row to the address

	clc
	lda M65_TXTROW_OFF+0
	adc M65_LPNT_SCR+0
	sta M65_LPNT_SCR+0	
	lda M65_TXTROW_OFF+1
	adc M65_LPNT_SCR+1
	sta M65_LPNT_SCR+1	

	rts



m65_helper_scrlpnt_to_screen:

	; Change M65_LPNT_SCR to point to screen memory (when it points to color memory)

	clc
	lda M65_SCRBASE+0
	adc M65_LPNT_SCR+0
	sta M65_LPNT_SCR+0
	lda M65_SCRBASE+1
	adc M65_LPNT_SCR+1
	sta M65_LPNT_SCR+1

	; FALLTROUGH

m65_helper_scrlpnt_to_screen_hi:

	lda M65_SCRSEG+1
	sta M65_LPNT_SCR+3
	lda M65_SCRSEG+0
	sta M65_LPNT_SCR+2

	rts



m65_helper_scrlpnt_chrin:

	; Prepare the pointer for CHRIN

	lda M65__SCRINPUT+0
	sta M65_LPNT_SCR+0
	lda M65__SCRINPUT+1
	sta M65_LPNT_SCR+1

	bra m65_helper_scrlpnt_to_screen_hi
