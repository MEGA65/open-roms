// #LAYOUT# M65 KERNAL_1 #TAKE
// #LAYOUT# *   *        #IGNORE



M65_CLRSCR:

	// Clear additional attributes from the color code

	jsr m65_screen_clear_colorattr

	// Disable the window mode

	lda #$00
	sta M65_SCRWINMODE

	// FALLTROUGH

m65_clrscr_takeover: // .A has to be 0

	// Set the viewport to the beginning of screen memory - variable:
	// - M65_COLVIEW
	// It will serve as line counter

	sta M65_COLVIEW+0
	sta M65_COLVIEW+1

	// Clear the row offset, so that it won't interfere

	sta M65_TXTROW_OFF+0
	sta M65_TXTROW_OFF+1

	// Clear the whole screen+color memory

	phz

	// FALLTROUGH

m65_clrscr_loop:

	// Prepare M65_LPNT_SCR, let it point to color memory

	jsr m65_helper_scrlpnt_color

	// Clear color for the whole line

	ldz #$4F                                     // 80 bytes
	lda COLOR
!:
	sta_lp (M65_LPNT_SCR),z

	dez
	bpl !-

	// Let M65_LPNT_SCR point to scren memory

	jsr m65_helper_scrlpnt_to_screen

	// Clear characters in the whole line

	ldz #$4F                                     // 80 bytes
	lda #$20
!:
	sta_lp (M65_LPNT_SCR),z

	dez
	bpl !-

	// Advance by one line, do next iteration

	// XXX this can probably be deduplicated
	clc
	lda M65_COLVIEW+0
	adc #$50
	sta M65_COLVIEW+0
	bcc !+
	inc M65_COLVIEW+1
!:
	// Check if we are allowed to progress further

	lda M65_COLVIEW+1
	cmp M65_COLGUARD+1
	bne m65_clrscr_loop
	lda M65_COLVIEW+0
	cmp M65_COLGUARD+0
	bne m65_clrscr_loop

m65_clrscr_loop_done:

	// Nothing more to clear - restore .Z register

	plz

	// Set screen+color base address in VIC IV
	// XXX deduplicate with mode setting routine

	lda #$00
	sta VIC_COLPTR+0
	sta VIC_COLPTR+1
	sta M65_COLVIEW+0
	sta M65_COLVIEW+1

	lda M65_SCRBASE+0
	sta VIC_SCRNPTR+0
	lda M65_SCRBASE+1
	sta VIC_SCRNPTR+1

    // Set screen variables

    jsr m65_screen_set_indx

	// XXX provide proper implementation

    // FALLTROUGH

m65_home: // XXX reuse

	// XXX provide proper implementation

	lda #$00
	sta M65__TXTROW
	sta M65__TXTCOL
	sta M65_TXTROW_OFF+0
	sta M65_TXTROW_OFF+1

	rts
