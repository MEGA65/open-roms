// #LAYOUT# M65 KERNAL_1 #TAKE
// #LAYOUT# *   *        #IGNORE


M65_CLRSCR:

	// Clear additional attributes from the color code

	lda COLOR
	and #$0F
	sta COLOR

	// Disable the window mode

	lda #$00
	sta M64_SCRWINMODE

	// FALLTROUGH

m65_clrscr_takeover:

	// Set the viewport to the beginning of screen memory - variables:
	// - M65_SCRVIEW, M65_COLVIEW
	// To clear the screen, two zeropage long pointers will be used, initialize them too
	// - M65_LPNT_SCR  for screen memory
	// - M65_LPNT_KERN for colour memory (starts from $FF80000)

	sta M65_COLVIEW+0
	sta M65_COLVIEW+1

	sta M65_LPNT_KERN+0
	sta M65_LPNT_KERN+1
	lda #$F8
	sta M65_LPNT_KERN+2
	lda #$0F
	sta M65_LPNT_KERN+3

	lda M65_SCRSEG+0
	sta M65_SCRVIEW+0
	lda M65_SCRSEG+1
	sta M65_SCRVIEW+1

	lda M65_SCRBASE+0
	sta M65_LPNT_SCR+0	
	lda M65_SCRBASE+1
	sta M65_LPNT_SCR+1
	lda M65_SCRSEG+0
	sta M65_LPNT_SCR+2
	lda M65_SCRSEG+1
	sta M65_LPNT_SCR+3

	// Clear the whole screen+color memory

	phz

	// FALLTROUGH

m65_clrscr_loop:

	// Clear 80 characters

	ldz #$4F                                     // 80 bytes
!:
	lda #$20
	sta_lp (M65_LPNT_SCR),z
	lda COLOR
	sta_lp (M65_LPNT_KERN),z

	dez
	bpl !-

	// Move M65_LPNT_SCR and M65_LPNT_KERN 80 characters forward
	// XXX deduplicate with window clearing

	clc
	lda M65_LPNT_SCR+0
	adc #$50
	sta M65_LPNT_SCR+0
	bcc !+
	inc M65_LPNT_SCR+1
!:
	clc
	lda M65_LPNT_KERN+0
	adc #$50
	sta M65_LPNT_KERN+0
	bcc !+
	inc M65_LPNT_KERN+1
!:
	// Check if we have more rows to clear

	lda M65_LPNT_SCR+1
	cmp M65_SCRGUARD+1
	bne m65_clrscr_loop
	lda M65_LPNT_SCR+0
	cmp M65_SCRGUARD+0
	bne m65_clrscr_loop

	// Restore .Z register

	plz

	// Set screen+color base address in VIC IV
	// XXX deduplicate with mode setting routine

	lda #$00
	sta VIC_COLPTR+0
	sta VIC_COLPTR+1

	lda M65_SCRBASE+0
	sta VIC_SCRNPTR+0
	lda M65_SCRBASE+1
	sta VIC_SCRNPTR+1

    // Set screen variables

	// XXX provide proper implementation, together with HOME

	lda #$00
	sta M65__TXTROW
	sta M65__TXTCOL

	rts
