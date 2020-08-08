// #LAYOUT# M65 KERNAL_1 #TAKE
// #LAYOUT# *   *        #IGNORE

//
// Input:
// - .A - desired screen mode
//
// Output:
// - Carry set   = unsupported screen mode
// - Carry clear = screen mode switched correctly
//


M65_SCRMODESET:

	cmp #$03
	bcs m65_scrmodeset_rts              // branch if unsupported screen mode

	// Preserve .X, move desired mode to .X, disable interrupts

	phx
	sei

	// Perform the switch

	jsr m65_scrmodeset_internal

	// Re-enable interrupts, restore .X

	cli
	plx

	// FALLTROUGH

m65_scrmodeset_rts:

	rts

m65_scrmodeset_internal: // entry point for M65_MODE65

	// Store desired screen mode

	sta M65_SCRMODE

	// Set the base screen addresses:
	// - in VIC_SCRNPTR and M65_SCRTXTBASE to $16000
	// - in VIC_COLPTR to $0000

	ldx #$00
	stx VIC_COLPTR+0
	stx VIC_COLPTR+1
	stx VIC_SCRNPTR+0
	stx M65_SCRTXTBASE+0
	stx VIC_SCRNPTR+3
	stx M65_SCRTXTBASE+3
	inx
	stx VIC_SCRNPTR+2
	stx M65_SCRTXTBASE+2
	ldx #$60
	stx VIC_SCRNPTR+1
	stx M65_SCRTXTBASE+1

	// Set flags for 40/80 columns and 25/50 rows

	asl
	tax
	lda VIC_SCFLAGS
	jsr_ind_x m65_scrmodeset_flagtab

	rts

m65_scrmodeset_flagtab:

	.word m65_scrmodeset_40x25
	.word m65_scrmodeset_80x25
	.word m65_scrmodeset_80x50


m65_scrmodeset_40x25:

	and #$77
	bra !+

m65_scrmodeset_80x25:

	and #$F7
	ora #$80
	skip_2_bytes_trash_nvz

	// FALLTROUGH

m65_scrmodeset_80x50:

	ora #$88
!:
	sta VIC_SCFLAGS
	rts
