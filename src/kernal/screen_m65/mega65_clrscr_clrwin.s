// #LAYOUT# M65 KERNAL_1 #TAKE
// #LAYOUT# *   *        #IGNORE


M65_CLRSCR:

	// Set the text window to whole screen area

	lda #$00
	sta M65_TXTWIN_X0
	sta M65_TXTWIN_Y0

	ldx M65_SCRMODE
	
	lda m65_scrtab_txtwidth, X
	sta M65_TXTWIN_X1
	lda m65_scrtab_txtheight, X
	sta M65_TXTWIN_Y1

	// FALLTROUGH

M65_CLRWIN:

	// To clear the window, two zeropage long pointers will be used:
	// - M65_LPNT_SCR  for screen memory
	// - M65_LPNT_KERN for colour memory (starts from $FF80000)

	// First initialize both pointers

	ldx #$03
!:
	lda M65_SCRTXTBASE,x
	sta M65_LPNT_SCR,x
    lda #$00
    sta M65_LPNT_KERN,x
    dex
    bpl !-

    lda #$0F
    sta M65_LPNT_KERN+3
    lda #$F8
    sta M65_LPNT_KERN+2

    // Go trough all the rows

    phz
    ldx M65_SCRMODE
    ldy #$00

    // FALLTROUGH

m65_clrwin_loop:

	// Check if .Y cordinate is not below the window

	cpy M65_TXTWIN_Y0
	bcc m65_clrwin_loop_next                     // branch if we should skip this row

	// Clear the row

	ldz M65_TXTWIN_X0
!:
	lda #$20
	sta_lp (M65_LPNT_SCR),z
	lda COLOR
	sta_lp (M65_LPNT_KERN),z
	inz
	cpz M65_TXTWIN_X1
	bne !-

	// FALLTROUGH

m65_clrwin_loop_next:

	// Increment M65_LPNT_SCR and M65_LPNT_KERN by the logical row length (always 80 = $50)

	clc
	lda #$50
	adc M65_LPNT_SCR+0
	sta M65_LPNT_SCR+0
	bcc !+
	inc M65_LPNT_SCR+1
!:
	clc
	lda #$50
	adc M65_LPNT_KERN+0
	sta M65_LPNT_KERN+0
	bcc !+
	inc M65_LPNT_KERN+1
!:
	// Increment row counter, check if new row is valid

	iny
	cpy M65_TXTWIN_Y1
	bne m65_clrwin_loop
    plz

    // Set screen variables

	// XXX implement this

	rts
