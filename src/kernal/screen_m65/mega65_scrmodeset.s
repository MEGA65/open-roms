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
	// stx VIC_CHARSTEP+0
	ldx #$00
	// stx VIC_CHARSTEP+1
	
	// Set the following locations:
	// - M64_SCRWINMODE                - for scroll-console mode
	// - M65_SCRSEG, VIC_SCRNPTR+2/+3  - for screen in $0001xxxx area

	stx M64_SCRWINMODE                           // .X = 0
	stx M65_SCRSEG+1                             
	stx VIC_SCRNPTR+3
	inx
	stx M65_SCRSEG+0	
	stx VIC_SCRNPTR+2

	// Set the following locations:
	// - M65_SCRBASE                   - for screen starting from $xxxx6000
	// - M65_SCRVIEW, VIC_SCRNPTR+0/+1 - for screen viewport starting from the same address
	// - M65_COLVIEW, VIC_COLPTR       - for using color memory from the start

	ldx #$60
	stx M65_SCRBASE+1
	stx M65_SCRVIEW+1
	stx VIC_SCRNPTR+1

	ldx #$00
	stx M65_SCRBASE+0
	stx M65_SCRVIEW+0
	stx VIC_SCRNPTR+0

	stx M65_COLVIEW+0
	stx M65_COLVIEW+1
	stx VIC_COLPTR+0
	stx VIC_COLPTR+1

	// Set the following locations:
	// - M65_SCREND                    - for max 200 lines of virtual screen
	// - M65_SCRVIEWMAX                - as above, but depending on the mode

	ldx #$80
	stx M65_SCRGUARD+0
	ldx #$9E
	stx M65_SCRGUARD+1

	ldx M65_SCRMODE
	lda m65_scrtab_viewmax_lo, x
	sta M65_SCRVIEWMAX+0
	lda m65_scrtab_viewmax_hi, x
	sta M65_SCRVIEWMAX+1

	rts
