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
    sta M65_LPNT_KERN+2
    lda #$F8
    sta M65_LPNT_KERN+1

    // Go trough all the rows

    phz
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
	lda #$00
	sta_lp (M65_LPNT_KERN),z
	inz
	cpz M65_TXTWIN_X1
	bne !-

	// FALLTROUGH

m65_clrwin_loop_next:

	iny

    // XXX

    plz


	// XXX implement this

	rts
