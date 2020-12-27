;; #LAYOUT# M65 KERNAL_1 #TAKE
;; #LAYOUT# *   *        #IGNORE


M65_CLRSCR: ; XXX consider integrating with M65_SCRMODESET

	; Clear additional attributes from the color code

	jsr m65_screen_clear_colorattr

	; Disable the window mode

	lda #$00
	sta M65_SCRWINMODE

	; FALLTROUGH

m65_clrscr_takeover:

	; Clear the whole screen + colour memory

	; Screen size
	lda M65_COLGUARD+0
	sta M65_DMAJOB_SIZE_0
	lda M65_COLGUARD+1
	sta M65_DMAJOB_SIZE_1


	; Fill screen memory with spaces
	jsr m65_screen_dmasrcdst_screen
	lda #$20
	jsr m65_dmagic_oper_fill

	; Fill color memory with the current color
	jsr m65_screen_dmasrcdst_color
	lda COLOR
	and #$0F
	jsr m65_dmagic_oper_fill

	; Set the viewport to the beginning of virtual screen
	; XXX deduplicate with mode setting routine

	lda #$00
	sta M65_COLVIEW+0
	sta M65_COLVIEW+1

	; Set screen+color base address in VIC IV
	; XXX deduplicate with mode setting routine

	sta VIC_COLPTR+0
	sta VIC_COLPTR+1
	sta M65_COLVIEW+0
	sta M65_COLVIEW+1

	lda M65_SCRBASE+0
	sta VIC_SCRNPTR+0
	lda M65_SCRBASE+1
	sta VIC_SCRNPTR+1

    ; Set logical row length

    jsr m65_screen_set_indx

    ; FALLTROUGH

M65_HOME:

	lda M65_SCRWINMODE
	bmi M65_HOME_winmode

	lda #$00
	sta M65__TXTROW
	sta M65__TXTCOL
	sta M65_TXTROW_OFF+0
	sta M65_TXTROW_OFF+1

	rts

M65_HOME_winmode:

	; XXX provide implementation

	rts
