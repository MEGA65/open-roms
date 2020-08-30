// #LAYOUT# M65 KERNAL_1 #TAKE
// #LAYOUT# *   *        #IGNORE

// #define DMAGIC_CLRSCR


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

#if DMAGIC_CLRSCR

	// XXX for some reason this does not work - find out, why

	// Clear the whole screen + colour memory

	// Screen size
	sec
	lda M65_COLGUARD+0
	sbc #$01
	sta M65_DMAJOB_SIZE_0
	lda M65_COLGUARD+1
	sbc #$00
	sta M65_DMAJOB_SIZE_1

	// Screen start address
	lda M65_SCRBASE+0
	sta M65_DMAJOB_DST_0
	lda M65_SCRBASE+1
	sta M65_DMAJOB_DST_1
	lda M65_SCRSEG+0
	sta M65_DMAJOB_DST_2
	lda M65_SCRSEG+1
	sta M65_DMAJOB_DST_3

	// Fill with spaces
	lda #$20
	jsr m65_dmagic_oper_fill

	// Colour RAM start address
	lda #$00
	sta M65_DMAJOB_DST_0
	sta M65_DMAJOB_DST_1
	lda #$F8
	sta M65_DMAJOB_DST_2
	lda #$0F
	sta M65_DMAJOB_DST_3

	// Fill with colour, without attributes
	lda COLOR
	and #$0F
	jsr m65_dmagic_oper_fill

#else

	// Clear the whole screen+color memory
	// XXX consider using DMAgic for this - FILL command

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

#endif // no DMAGIC_CLRSCR

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

	// XXX provide implementation

	rts
