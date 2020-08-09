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

	// Set flags/variables for 40/80 columns and 25/50 rows

	tax

	lda m65_scrtab_vic_ctrlb,x
	sta VIC_CTRLB

	// Set the logical row length to 80

	ldx #$50
	stx VIC_CHARSTEP+0
	ldx #$00
	stx VIC_CHARSTEP+1
	
	// Set the base screen addresses:
	// - in VIC_SCRNPTR and M65_SCRTXTBASE to $16000
	// - in VIC_COLPTR to $0000

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

	rts
